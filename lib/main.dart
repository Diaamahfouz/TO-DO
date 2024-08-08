import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/home_screen.dart';

void main() {
  runApp( TodoApp());
}
class TodoApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routename :(_) =>HomeScreen(),
      },
      theme: AppTheme.lightheme,
      darkTheme:AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    

    );
  }
}