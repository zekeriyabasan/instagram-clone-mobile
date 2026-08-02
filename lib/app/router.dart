import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text("Instagram Clone", style: TextStyle(fontSize: 28)),
            ),
          );
        },
      ),
    ],
  );
}
