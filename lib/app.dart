import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/generated/l10n.dart';
import 'package:wildlife_nl_app/nav.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';

import 'utilities/app_colors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyleProvider(
      child: ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('nl'),
            Locale('de'),
          ],
          debugShowCheckedModeBanner: false,
          title: "WildlifeNL",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            navigationBarTheme: NavigationBarThemeData(
              iconTheme: MaterialStateProperty.resolveWith((state) {
                if (state.contains(MaterialState.selected)) {
                  return const IconThemeData(color: AppColors.primary);
                }
                return IconThemeData(color: Colors.black.withOpacity(0.7));
              }),
              labelTextStyle: MaterialStateProperty.resolveWith((state) {
                if (state.contains(MaterialState.selected)) {
                  return const TextStyle(
                      color: AppColors.primary, fontSize: 12, height: 0.7);
                }
                return TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 12,
                    height: 0.7);
              }),
            ),
            useMaterial3: true,
          ),
          home: const BottomNavigation(),
        ),
      ),
    );
  }
}
