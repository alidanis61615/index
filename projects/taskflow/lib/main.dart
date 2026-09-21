import 'package:flutter/material.dart';

import 'controllers/theme_controller.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.load();

  runApp(TaskFlowApp(themeController: themeController));
}

class TaskFlowApp extends StatelessWidget {
  final ThemeController themeController;

  const TaskFlowApp({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskFlow',
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
            ),
            scaffoldBackgroundColor: const Color(0xFFF6F8FB),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF64B5F6),
              brightness: Brightness.dark,
            ),
          ),
          home: HomeScreen(themeController: themeController),
        );
      },
    );
  }
}
