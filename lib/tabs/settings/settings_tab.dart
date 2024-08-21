import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                color: AppTheme.primary,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: settingsProvider.isDark,
                      onChanged: (isDark) async {
                        await settingsProvider.changeThemeMode(
                            isDark ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeTrackColor: AppTheme.green,
                      inactiveTrackColor: AppTheme.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseFunctions.logout();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        Provider.of<TasksProvider>(context, listen: false)
                            .tasks
                            .clear();
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUser(null);
                      },
                      icon: Icon(
                        Icons.logout_outlined,
                        size: 32,
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
