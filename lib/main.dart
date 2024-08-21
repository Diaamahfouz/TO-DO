import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/register_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/edit_task_screen.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => settingsProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
        builder: (BuildContext context, dynamic provider, Widget? child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.routename: (_) => const HomeScreen(),
          EditTaskScreen.routename: (_) => const EditTaskScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
        },
        initialRoute: LoginScreen.routeName,
        darkTheme: AppTheme.darkTheme,
        themeMode: SettingsProvider.themeMode,
        theme: AppTheme.lighTheme,
      );
    });
  }
}
