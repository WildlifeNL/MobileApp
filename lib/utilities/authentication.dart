import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

class Authentication extends InheritedWidget {
  const Authentication({
    super.key,
    required this.data,
    required super.child,
  });

  final AuthenticationData data;

  static AuthenticationData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Authentication>()?.data;
  }

  static AuthenticationData of(BuildContext context) {
    final AuthenticationData? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Authentication oldWidget) => data != oldWidget.data;
}

class AuthenticationData {
  final String userId;

  AuthenticationData({required this.userId});
}

class AuthenticationProvider extends StatelessWidget {
  final Widget child;

  const AuthenticationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = LocalStorage('wildlifenl');

    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          String? userId = storage.getItem('user_id');

          if (userId == null) {
            var uuid = const Uuid();
            userId = uuid.v4();
            storage.setItem("user_id", userId);
          }

          return Authentication(
            data: AuthenticationData(userId: userId),
            child: child,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
