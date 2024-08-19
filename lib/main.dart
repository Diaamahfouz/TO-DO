import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/register_screen.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/edit_task_screen.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.disableNetwork();
  var settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksProvider()..getTasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => settingsProvider,
        )
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  Consumer<SettingsProvider>(
        builder: (BuildContext context, dynamic provider, Widget? child)  {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            HomeScreen.routename: (_) => const HomeScreen(),
            EditTaskScreen.routename: (_) => const EditTaskScreen(),
            RegisterScreen.routeName: (_) => const RegisterScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
          },
          initialRoute: RegisterScreen.routeName,
          darkTheme: AppTheme.darkTheme,
          themeMode: SettingsProvider.themeMode,
          theme: AppTheme.lighTheme,
        );
      }
    );
  }
}
