import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/settings_provider.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
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
                    style: titleMediumStyle?.copyWith(fontSize: 30),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: titleMediumStyle?.copyWith(fontSize: 24),
                ),
                Switch(
                  value: settingsProvider.isDark,
                  onChanged: (isDark) {
                    settingsProvider.changeThemeMode(
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
