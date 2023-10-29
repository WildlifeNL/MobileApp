import 'package:flutter/material.dart';

class BaseModal extends StatelessWidget {
  const BaseModal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var height = 475;

      return SizedBox(
        width: constraints.maxWidth,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child,
        ),
      );
    });
  }
}
