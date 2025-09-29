import 'package:flutter/material.dart';
import '../utils/notif_helper.dart';

class ReminderProvider extends ChangeNotifier {
  final NotificationHelper _notificationHelper = NotificationHelper();

  bool _isReminderActive = false;
  bool get isReminderActive => _isReminderActive;

  ReminderProvider() {
    init();
  }

  Future<void> init() async {
    await _notificationHelper.init();
  }

  Future<void> toggleReminder() async {
    if (_isReminderActive) {
      await _notificationHelper.cancelAll(); // ✅ ganti ini
    } else {
      await _notificationHelper.scheduleDailyReminder(); // ✅ ini sudah benar
    }
    _isReminderActive = !_isReminderActive;
    notifyListeners();
  }

  Future<void> triggerTestNotif() async {
    await _notificationHelper.showNotification(
      id: 999,
      title: "Test Notif",
      body: "Notif langsung muncul ✅",
    ); // ✅ ganti
  }
}
