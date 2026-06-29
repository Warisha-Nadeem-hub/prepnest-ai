import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_boost/screens/splash_screen.dart';
import 'package:mind_boost/services/notification_service.dart';
import 'package:mind_boost/services/storage_service.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/providers/providers.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline caching (Hive)
  await StorageService.init();

  await StorageService.setOnboarded(false);

  // Initialize local study reminders notifications
  await NotificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp(
      title: 'Interview Buddy',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
