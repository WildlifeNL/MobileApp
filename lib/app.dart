import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/nav.dart';

import 'flavors.dart';
import 'utilities/app_colors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "WildlifeNL",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          navigationBarTheme: NavigationBarThemeData(
            iconTheme: MaterialStateProperty.resolveWith((state) {
              if(state.contains(MaterialState.selected)){
                return const IconThemeData(color: AppColors.primary);
              }
                return IconThemeData(color: Colors.black.withOpacity(0.7));
            }),
            labelTextStyle: MaterialStateProperty.resolveWith((state) {
              if (state.contains(MaterialState.selected)) {
                return const TextStyle(color: AppColors.primary, fontSize: 12, height: 0.7);
              }
              return TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12, height: 0.7);
            }),
          ),
          useMaterial3: true,
        ),
        home: const BottomNavigation(),
      ),
    );
  }
}
