import 'package:flutter/material.dart';

class BaseModal extends StatelessWidget {
  const BaseModal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: child,
      );
    });
  }
}
