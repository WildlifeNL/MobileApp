import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

class CustomAttributionWidget extends StatelessWidget {
  const CustomAttributionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform:
          Matrix4.translationValues(0, Platform.isAndroid ? -100 : -104, 0),
      child: RichAttributionWidget(
        popupInitialDisplayDuration: const Duration(seconds: 3),
        animationConfig: const FadeRAWA(
            popupDuration: Duration(milliseconds: 200),
            popupCurveIn: Easing.standardDecelerate,
            popupCurveOut: Easing.standardAccelerate),
        popupBackgroundColor: AppColors.neutral_50,
        attributions: [
          TextSourceAttribution(
            "OpenStreetMap contributors",
            onTap: () async {
              if (!await launchUrlString(
                  "https://www.openstreetmap.org/copyright")) {
                developer.log(
                    "Couldn't launch https://www.openstreetmap.org/copyright");
              }
            },
            textStyle: GoogleFonts.inter(),
          ),
        ],
      ),
    );
  }
}
