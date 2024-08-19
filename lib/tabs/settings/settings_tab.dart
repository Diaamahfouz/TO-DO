import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/settings_provider.dart';

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
            child: Row(
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
                  onChanged: (isDark)async {
                 await   settingsProvider.changeThemeMode(
                        isDark ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeTrackColor: AppTheme.green,
                  inactiveTrackColor: AppTheme.grey,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
