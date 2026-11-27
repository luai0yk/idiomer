import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Abstract contract for scheduling and cancelling local idiom reminder
/// notifications, enabling clean unit testing without platform channels.
abstract interface class NotificationService {
  Stream<String?> get onNotificationTap;

  Future<void> init();

  Future<String?> getLaunchNotificationPayload();

  Future<bool> requestPermissions();

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String channelName,
    required String channelDescription,
    String? payload,
  });

  Future<void> cancelRange({required int startId, required int count});

  Future<void> dispose();
}

/// Concrete [NotificationService] backed by [FlutterLocalNotificationsPlugin]
/// and device local timezone resolution.
class LocalNotificationService implements NotificationService {
  static const String _reminderChannelId = 'idiom_reminders';

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String?> _tapController =
      StreamController<String?>.broadcast();

  bool _initialized = false;
  bool _timeZoneInitialized = false;

  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Stream<String?> get onNotificationTap => _tapController.stream;

  @override
  Future<void> init() async {
    if (_initialized) return;
    await _ensureTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            _tapController.add(payload);
          }
        },
      );
      _initialized = true;
    } on MissingPluginException {
      _initialized = false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('NotificationService init failed: $error\n$stackTrace');
      }
      _initialized = false;
    }
  }

  Future<void> _ensureTimeZone() async {
    if (_timeZoneInitialized) return;
    tz_data.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    _timeZoneInitialized = true;
  }

  @override
  Future<String?> getLaunchNotificationPayload() async {
    await init();
    if (!_initialized) return null;
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details == null || !details.didNotificationLaunchApp) {
        return null;
      }
      final payload = details.notificationResponse?.payload;
      if (payload == null || payload.isEmpty) return null;
      return payload;
    } on MissingPluginException {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    await init();
    if (!_initialized) return false;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (android == null) return true;
        final granted = await android.requestNotificationsPermission();
        return granted ?? true;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        if (ios == null) return true;
        final granted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      return true;
    } on MissingPluginException {
      return false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'NotificationService requestPermissions failed: $error\n$stackTrace',
        );
      }
      return false;
    }
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact = await android?.canScheduleExactNotifications();
      if (canExact == true) {
        return AndroidScheduleMode.exactAllowWhileIdle;
      }
    } catch (_) {
      // Fall back to inexact alarm if exact alarm status cannot be queried.
    }
    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String channelName,
    required String channelDescription,
    String? payload,
  }) async {
    await init();
    if (!_initialized) return;

    try {
      final scheduleMode = defaultTargetPlatform == TargetPlatform.android
          ? await _resolveAndroidScheduleMode()
          : AndroidScheduleMode.inexactAllowWhileIdle;

      final tzDate = tz.TZDateTime(
        tz.local,
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
        scheduledAt.hour,
        scheduledAt.minute,
        scheduledAt.second,
      );

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          styleInformation: BigTextStyleInformation(body, contentTitle: title),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: details,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
    } on MissingPluginException {
      // Ignore on unsupported platforms/tests.
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'NotificationService scheduleNotification($id) failed: $error\n$stackTrace',
        );
      }
    }
  }

  @override
  Future<void> cancelRange({required int startId, required int count}) async {
    await init();
    if (!_initialized) return;

    try {
      for (int i = 0; i < count; i++) {
        await _plugin.cancel(id: startId + i);
      }
    } on MissingPluginException {
      // Ignore on unsupported platforms/tests.
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'NotificationService cancelRange failed: $error\n$stackTrace',
        );
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _tapController.close();
  }
}
