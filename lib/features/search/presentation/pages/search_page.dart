import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers/providers.dart';
import 'package:weatherly/domain/entities/weather.dart';
import 'package:weatherly/core/theme/app_colors.dart';
import 'package:weatherly/core/widgets/weather_background.dart';
import 'package:weatherly/core/localization/app_localizations.dart';
import 'package:weatherly/features/favorites/presentation/pages/favorites_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  final String? currentCondition;

  const SearchPage({super.key, this.currentCondition});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  List<Location>? _searchResults;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = null;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repository = ref.read(locationRepositoryProvider);
    final result = await repository.searchLocations(query);

    setState(() {
      _searchResults = result.data;
      if (result.error != null) {
        _errorMessage = result.error!.message;
      }
      _isLoading = false;
    });
  }

  String _getBackgroundCondition() {
    if (widget.currentCondition != null) {
      return widget.currentCondition!;
    }

    final hour = DateTime.now().hour;
    final isNight = hour < 6 || hour >= 18;
    return isNight ? 'clear_night' : 'sunny';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final condition = _getBackgroundCondition();
    final textColor = AppColors.getTextColorForCondition(condition);

    return WeatherBackground(
      condition: condition,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: textColor),
          title: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: l10n.searchLocation,
                hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: textColor.withOpacity(0.7)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = null;
                    });
                  },
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _performSearch,
            ),
          ),
        ),
        body: _buildBody(l10n, textColor),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, Color textColor) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 18, color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchResults == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: textColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              l10n.searchForCity,
              style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    if (_searchResults!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noLocationsFound,
              style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    final favoritesAsync = ref.watch(favoritesProvider);
    final favorites = favoritesAsync.value ?? [];

    return ListView.builder(
      itemCount: _searchResults!.length,
      itemBuilder: (context, index) {
        final location = _searchResults![index];
        final isFavorite = favorites.any(
          (fav) =>
              fav.latitude == location.latitude &&
              fav.longitude == location.longitude,
        );

        return ListTile(
          leading: Icon(Icons.location_on, color: textColor),
          title: Text(location.name, style: TextStyle(color: textColor)),
          subtitle: Text(
            '${location.state ?? ''} ${location.country ?? ''}'.trim(),
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : textColor.withOpacity(0.7),
            ),
            onPressed: () async {
              final repository = ref.read(locationRepositoryProvider);
              if (isFavorite) {
                await repository.removeFavoriteLocation(location);
              } else {
                await repository.addFavoriteLocation(
                  location.copyWith(isFavorite: true),
                );
              }
              ref.invalidate(favoritesProvider);
            },
          ),
          onTap: () {
            Navigator.pop(context, location);
          },
        );
      },
    );
  }
}
