import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/reminder_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Theme"),
            value: themeProvider.isDarkTheme,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),
          SwitchListTile(
            title: const Text("Daily Reminder (11:00)"),
            value: reminderProvider.isReminderActive,
            onChanged: (_) => reminderProvider.toggleReminder(),
          ),
          ListTile(
            title: const Text("Test Notif Langsung"),
            trailing: ElevatedButton(
              onPressed: () => reminderProvider.triggerTestNotif(),
              child: const Text("Coba 🔔"),
            ),
          ),
          ListTile(
            title: const Text("Test Reminder (1 menit)"),
            trailing: ElevatedButton(
              onPressed: () => reminderProvider.triggerTestNotif(),
              child: const Text("Coba ⏰"),
            ),
          ),
        ],
      ),
    );
  }
}
