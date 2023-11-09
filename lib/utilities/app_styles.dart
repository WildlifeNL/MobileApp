import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_text_styles.dart';

class AppStyles extends InheritedWidget {
  const AppStyles({
    super.key,
    required this.data,
    required super.child,
  });

  final AppStyleData data;

  static AppStyles? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStyles>();
  }

  static AppStyles of(BuildContext context) {
    final AppStyles? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppStyles oldWidget) => data != oldWidget.data;
}

class AppStyleData {
  final AppTextStyle textStyle;

  AppStyleData({required this.textStyle});
}

class AppStyleProvider extends StatelessWidget {
  final Widget child;

  const AppStyleProvider({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var textStyle = AppTextStyle.init();

    return AppStyles(
      data: AppStyleData(textStyle: textStyle),
      child: child,
    );
  }
}
