import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationServices(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

 Future<void> sentNotification(RemoteMessage message) async{
    AndroidNotificationDetails androidNotificationDetails =
   AndroidNotificationDetails('channel01', 'promo code',
       channelDescription: 'your channel description',
       importance: Importance.max,
       priority: Priority.high,
       ticker: 'ticker');
    NotificationDetails notificationDetails =
   NotificationDetails(android: androidNotificationDetails);
   await flutterLocalNotificationsPlugin.show(
       0, message.notification!.title, message.notification!.body, notificationDetails,
       payload: 'item x');
 }
}