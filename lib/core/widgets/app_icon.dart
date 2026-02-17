import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final double size;

  const AppIcon({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final assetName = brightness == Brightness.dark
        ? 'assets/images/icons/weather_dark.svg'
        : 'assets/images/icons/weather_light.svg';

    return SvgPicture.asset(assetName, width: size, height: size);
  }
}
