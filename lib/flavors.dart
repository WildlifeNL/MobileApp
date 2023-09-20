import 'package:flutter/material.dart';

enum Flavor {
  dev,
  staging,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static Color get color {
    switch (appFlavor) {
      case Flavor.dev:
        return const Color(0xFFF5202A);
      case Flavor.staging:
        return const Color(0xFF9751F5);
      default:
        return const Color(0xFF57A826);
    }
  }

  static String get nameHumanized {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Dev';
      case Flavor.staging:
        return 'Beta';
      default:
        return 'Prod';
    }
  }
}
