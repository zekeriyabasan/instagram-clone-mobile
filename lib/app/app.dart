import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class InstagramCloneApp extends StatelessWidget {
  const InstagramCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Instagram Clone",
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
