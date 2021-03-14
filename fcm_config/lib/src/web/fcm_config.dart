import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'web_notification_manager.dart';

class FCMConfig {
  static Future<RemoteMessage?> getInitialMessage() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  static Future init({
    /// this function will be excuted while application is in background
    BackgroundMessageHandler? onBackgroundMessage,

    /// Drawable icon works only in forground
    String? appAndroidIcon,

    /// Required to show head up notification in foreground
    String? androidChannelId,

    /// Required to show head up notification in foreground
    String? androidChannelName,

    /// Required to show head up notification in foreground
    String? androidChannelDescription,

    /// Request permission to display alerts. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool alert = true,

    /// Request permission for Siri to automatically read out notification messages over AirPods.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool announcement = false,

    /// Request permission to update the application badge. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool badge = true,

    /// Request permission to display notifications in a CarPlay environment.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool carPlay = false,

    /// Request permission for critical alerts. Defaults to `false`.
    ///
    /// Note; your application must explicitly state reasoning for enabling
    /// critical alerts during the App Store review process or your may be
    /// rejected.
    ///
    /// iOS only.
    bool criticalAlert = false,

    /// Request permission to provisionally create non-interrupting notifications.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool provisional = false,

    /// Request permission to play sounds. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool sound = true,

    /// Options to pass to core intialization method
    FirebaseOptions? options,

    ///Name of the firebase instance app
    String? name,
    bool displayInForeground = true,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(name: name, options: options);
    await FirebaseMessaging.instance.requestPermission(
      alert: alert,
      announcement: announcement,
      criticalAlert: criticalAlert,
      badge: badge,
      carPlay: carPlay,
      sound: sound,
      provisional: provisional,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
    if (onBackgroundMessage != null) {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    }
  }

  ///Call to FirebaseMessaging.instance.deleteToken();
  static Future<void> deleteToken({String? senderId}) =>
      FirebaseMessaging.instance.deleteToken(senderId: senderId);

  ///Call to FirebaseMessaging.instance.getAPNSToken();
  static Future<String?> getAPNSToken() =>
      FirebaseMessaging.instance.getAPNSToken();

  ///Call to FirebaseMessaging.instance.getNotificationSettings();
  static Future<NotificationSettings> getNotificationSettings() =>
      FirebaseMessaging.instance.getNotificationSettings();

  ///Call to FirebaseMessaging.instance.getToken();
  static Future<String?> getToken({String? vapidKey}) =>
      FirebaseMessaging.instance.getToken(vapidKey: vapidKey);

  ///Call to FirebaseMessaging.instance.isAutoInitEnabled();
  static bool get isAutoInitEnabled =>
      FirebaseMessaging.instance.isAutoInitEnabled;

  ///Call to FirebaseMessaging.instance.onTokenRefresh();
  static Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  ///Call to FirebaseMessaging.instance.pluginConstants;
  static Map get pluginConstants => FirebaseMessaging.instance.pluginConstants;

  ///Call to FirebaseMessaging.instance.sendMessage();
  static Future<void> sendMessage({
    String? to,
    Map<String, String>? data,
    String? collapseKey,
    String? messageId,
    String? messageType,
    int? ttl,
  }) =>
      FirebaseMessaging.instance.sendMessage(
        to: to,
        data: data,
        collapseKey: collapseKey,
        messageId: messageId,
        messageType: messageType,
        ttl: ttl,
      );

  ///Call to FirebaseMessaging.instance.subscribeToTopic();
  ///Not supported in web
  static Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  ///Call to FirebaseMessaging.instance.unsubscribeFromTopic();
  ///Not supported in web
  static Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);

  static void displayNotification({
    required String title,
    required String body,

    ///This is required to display in the web
    required BuildContext? context,
    String? subTitle,
    String? category,
    String? collapseKey,
    dynamic? sound,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    Map<String, dynamic>? data,
  }) {
    if (context == null) {
      throw Exception('context is required to display messages in the web');
    }
    var details = WebNotificationDetails(
      title: title,
      body: body,
    );
    WebNotificationManager.show(context, details, data);
  }

  static void displayNotificationWithAndroidStyle({
    required String title,
    required dynamic styleInformation,
    required String body,
    required BuildContext? context,
    String? subTitle,
    String? category,
    String? collapseKey,
    dynamic? sound,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    Map<String, dynamic>? data,
  }) {
    if (context == null) {
      throw Exception('context is required to display messages in the web');
    }
    var details = WebNotificationDetails(
      title: title,
      body: body,
    );
    WebNotificationManager.show(context, details, data);
  }

  static void displayNotificationWith({
    required String title,
    String? body,
    Map<String, dynamic>? data,
    required dynamic android,
    required dynamic iOS,
    required WebNotificationDetails web,
    required BuildContext? context,
  }) {
    if (context == null) {
      throw Exception('context is required to display messages in the web');
    }
    WebNotificationManager.show(context, web, data);
  }
}