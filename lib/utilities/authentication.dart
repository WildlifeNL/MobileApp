import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/flavors.dart';

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

class AuthenticationProvider extends StatefulWidget {
  final Widget child;

  const AuthenticationProvider({super.key, required this.child});

  @override
  State<AuthenticationProvider> createState() => _AuthenticationProviderState();
}

class _AuthenticationProviderState extends State<AuthenticationProvider> {
  bool hasAddedUser = false;

  void addNewUser(String userId) async {
    final String apiUrl = '${F.apiUrl}api/controllers/users.php';

    Map<String, Object?> report = {
      'Id': userId,
      'Role': "43510ba1-89f2-11ee-919a-1e0034001676",
    };

    String jsonData = jsonEncode(report);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonData,
      );
    } catch (error) {
      //
    }
  }

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

          if (!hasAddedUser) {
            addNewUser(userId);
          }

          return Authentication(
            data: AuthenticationData(userId: userId),
            child: widget.child,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
