import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherly/core/errors/app_error.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/core/providers/settings_providers.dart';
import 'package:weatherly/core/utils/unit_converter.dart';
import 'package:weatherly/domain/entities/weather.dart';

class MapPage extends ConsumerStatefulWidget {
  final Location? location;

  const MapPage({super.key, this.location});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  String? _rainViewerUrlTemplate;
  String? _rainViewerHost;
  final Dio _dio = Dio();
  final MapController _mapController = MapController();
  final TileProvider _tileProvider = CancellableNetworkTileProvider();
  final List<_RadarFrame> _radarFrames = [];
  int _currentFrameIndex = 0;
  Timer? _playbackTimer;
  bool _isPlaying = false;
  bool _showRadar = true;
  bool _showClouds = false;
  bool _showTemperature = false;
  LatLng? _selectedPoint;
  Weather? _selectedPointWeather;
  bool _isLoadingPointWeather = false;
  String? _selectedPointName;
  String? _pointError;
  late final String _apiKey;

  @override
  void initState() {
    super.initState();
    _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    _fetchRainViewerConfig();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchRainViewerConfig() async {
    try {
      final response = await _dio.get(
        'https://api.rainviewer.com/public/weather-maps.json',
      );
      final data = response.data;
      final host = data['host'] as String?;
      final radar = data['radar'] as Map<String, dynamic>?;
      final past = (radar?['past'] as List?) ?? const [];
      final nowcast = (radar?['nowcast'] as List?) ?? const [];

      if (host == null) {
        return;
      }

      final frames = <_RadarFrame>[];
      for (final item in past) {
        final path = item['path'] as String?;
        final time = item['time'] as int?;
        if (path != null && time != null) {
          frames.add(_RadarFrame(path: path, time: time, isNowcast: false));
        }
      }
      for (final item in nowcast) {
        final path = item['path'] as String?;
        final time = item['time'] as int?;
        if (path != null && time != null) {
          frames.add(_RadarFrame(path: path, time: time, isNowcast: true));
        }
      }

      if (frames.isEmpty) {
        return;
      }

      setState(() {
        _rainViewerHost = host;
        _radarFrames
          ..clear()
          ..addAll(frames);
        _currentFrameIndex = frames.length - 1;
        _rainViewerUrlTemplate = _buildTemplate(host, frames[_currentFrameIndex].path);
      });
    } catch (e) {
      debugPrint('Error fetching RainViewer config: $e');
    }
  }

  String _buildTemplate(String host, String path) {
    // {host}{path}/256/{z}/{x}/{y}/2/1_1.png
    return '$host$path/256/{z}/{x}/{y}/2/1_1.png';
  }

  void _setFrameIndex(int index) {
    if (_radarFrames.isEmpty) return;
    final clamped = index.clamp(0, _radarFrames.length - 1);
    setState(() {
      _currentFrameIndex = clamped;
      if (_rainViewerHost != null) {
        _rainViewerUrlTemplate = _buildTemplate(
          _rainViewerHost!,
          _radarFrames[_currentFrameIndex].path,
        );
      }
    });
  }

  void _togglePlayback() {
    if (_radarFrames.isEmpty) return;
    if (_isPlaying) {
      _playbackTimer?.cancel();
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    setState(() {
      _isPlaying = true;
    });

    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      final next = (_currentFrameIndex + 1) % _radarFrames.length;
      _setFrameIndex(next);
    });
  }

  String _formatFrameTime(_RadarFrame frame) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(frame.time * 1000).toLocal();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final label = frame.isNowcast ? 'Nowcast' : 'Past';
    return '$hour:$minute · $label';
  }

  String _openWeatherTileUrl(String layer) {
    return 'https://tile.openweathermap.org/map/$layer/{z}/{x}/{y}.png?appid=$_apiKey';
  }

  Future<void> _handleMapTap(LatLng point) async {
    setState(() {
      _selectedPoint = point;
      _isLoadingPointWeather = true;
      _selectedPointWeather = null;
      _selectedPointName = null;
      _pointError = null;
    });

    final weatherRepository = ref.read(weatherRepositoryProvider);
    final locationRepository = ref.read(locationRepositoryProvider);
    final unitsAsync = ref.read(weatherApiUnitsProvider);
    final units = await unitsAsync.when(
      data: (u) async => u,
      loading: () async => 'metric',
      error: (error, stackTrace) async => 'metric',
    );

    final weatherResult = await weatherRepository.getCurrentWeather(
      latitude: point.latitude,
      longitude: point.longitude,
      units: units,
    );
    final locationResult = await locationRepository.reverseGeocode(
      latitude: point.latitude,
      longitude: point.longitude,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingPointWeather = false;
      _selectedPointWeather = weatherResult.data;
      _selectedPointName = locationResult.data?.name ?? 'Pinned location';
      _pointError = _extractErrorMessage(weatherResult.error);
    });
  }

  String? _extractErrorMessage(AppError? error) {
    if (error == null) return null;
    if (error is NetworkError) return error.message;
    if (error is ServerError) return error.message;
    if (error is LocationError) return error.message;
    if (error is PermissionError) return error.message;
    if (error is CacheError) return error.message;
    if (error is UnknownError) return error.message;
    return 'Unknown error';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.location == null) {
      return const Center(
        child: Text('Please select a location to view radar'),
      );
    }

    final unitPreferenceAsync = ref.watch(unitPreferenceProvider);
    final displayUnit = unitPreferenceAsync.value ?? 'metric';
    final initialPosition = LatLng(
      widget.location!.latitude,
      widget.location!.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Radar - ${widget.location!.name}')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialPosition,
              initialZoom: 8.0,
              onTap: (tapPosition, point) => _handleMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.yourorg.weatherly',
                tileProvider: _tileProvider,
              ),
              if (_showRadar && _rainViewerUrlTemplate != null)
                TileLayer(
                  urlTemplate: _rainViewerUrlTemplate!,
                  userAgentPackageName: 'com.yourorg.weatherly',
                  tileProvider: _tileProvider,
                ),
              if (_showClouds && _apiKey.isNotEmpty)
                TileLayer(
                  urlTemplate: _openWeatherTileUrl('clouds_new'),
                  userAgentPackageName: 'com.yourorg.weatherly',
                  tileProvider: _tileProvider,
                ),
              if (_showTemperature && _apiKey.isNotEmpty)
                TileLayer(
                  urlTemplate: _openWeatherTileUrl('temp_new'),
                  userAgentPackageName: 'com.yourorg.weatherly',
                  tileProvider: _tileProvider,
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: initialPosition,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (_selectedPoint != null)
                    Marker(
                      point: _selectedPoint!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.lightBlueAccent,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (_showRadar && _rainViewerUrlTemplate == null)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              color: Colors.black.withOpacity(0.72),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('Radar'),
                      selected: _showRadar,
                      onSelected: (value) {
                        setState(() {
                          _showRadar = value;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Clouds'),
                      selected: _showClouds,
                      onSelected: _apiKey.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _showClouds = value;
                              });
                            },
                    ),
                    FilterChip(
                      label: const Text('Temperature'),
                      selected: _showTemperature,
                      onSelected: _apiKey.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _showTemperature = value;
                              });
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_selectedPoint != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: (_showRadar && _radarFrames.isNotEmpty) ? 170 : 16,
              child: Card(
                color: Colors.black.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildPointWeatherCard(displayUnit),
                ),
              ),
            ),
          if (_rainViewerUrlTemplate != null && _radarFrames.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _togglePlayback,
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle : Icons.play_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatFrameTime(_radarFrames[_currentFrameIndex]),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _setFrameIndex(_currentFrameIndex - 1),
                            icon: const Icon(Icons.skip_previous, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () => _setFrameIndex(_currentFrameIndex + 1),
                            icon: const Icon(Icons.skip_next, color: Colors.white),
                          ),
                        ],
                      ),
                      Slider(
                        value: _currentFrameIndex.toDouble(),
                        min: 0,
                        max: (_radarFrames.length - 1).toDouble(),
                        divisions: _radarFrames.length > 1
                            ? _radarFrames.length - 1
                            : null,
                        onChanged: (value) {
                          _setFrameIndex(value.round());
                        },
                        activeColor: Colors.lightBlueAccent,
                        inactiveColor: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedPoint != null) {
            _mapController.move(_selectedPoint!, _mapController.camera.zoom);
            return;
          }
          _mapController.move(initialPosition, 8.0);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildPointWeatherCard(String displayUnit) {
    if (_isLoadingPointWeather) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('Loading weather...', style: TextStyle(color: Colors.white)),
        ],
      );
    }

    if (_pointError != null) {
      return Text(
        _pointError!,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
    }

    if (_selectedPointWeather == null || _selectedPoint == null) {
      return const Text(
        'Tap anywhere on the map to inspect weather.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
    }

    final weather = _selectedPointWeather!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedPointName ?? 'Pinned location',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_selectedPoint!.latitude.toStringAsFixed(3)}, ${_selectedPoint!.longitude.toStringAsFixed(3)}',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          weather.description,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              UnitConverter.formatTemperature(weather.temperature, displayUnit),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Wind ${UnitConverter.formatWindSpeed(weather.windSpeed, displayUnit)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadarFrame {
  final String path;
  final int time;
  final bool isNowcast;

  const _RadarFrame({
    required this.path,
    required this.time,
    required this.isNowcast,
  });
}
