import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:push_notifications/firebase_options.dart';
import 'package:push_notifications/push_notification_server_key.dart';

// Background handler for FCM notifications
Future<void> backGroundHandler(RemoteMessage message) async {
  String? title = message.notification?.title;
  String? body = message.notification?.body;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      duration: Duration(seconds: 9),
      channelKey: "Call_Channel",
      color: Colors.white,
      title: title,
      body: body,
      category: NotificationCategory.Call,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.orange,
    ),
    actionButtons: [
      NotificationActionButton(
          key: "REJECT", label: "Reject Call", color: Colors.red, autoDismissible: true),
      NotificationActionButton(
          key: "ACCEPT", label: "Accept Call", color: Colors.green, autoDismissible: true),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "Call_Channel",
        channelName: "Call_Channel",
        channelDescription: "Channel for incoming calls",
        defaultColor: Colors.green,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ),
    ],
  );

  FirebaseMessaging.onBackgroundMessage(backGroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123,
          duration: Duration(seconds: 9),
          channelKey: "Call_Channel",
          color: Colors.white,
          title: title,
          body: body,
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.orange,
        ),
        actionButtons: [
          NotificationActionButton(
              key: "REJECT", label: "Reject Call", color: Colors.red, autoDismissible: true),
          NotificationActionButton(
              key: "ACCEPT", label: "Accept Call", color: Colors.green, autoDismissible: true),
        ],
      );
    });

    // AwesomeNotifications().actionStream.listen((receivedAction) {
    //   if (receivedAction.buttonKeyPressed == "REJECT") {
    //     print("Call rejected");
    //   } else if (receivedAction.buttonKeyPressed == "ACCEPT") {
    //     print("Call accepted");
    //   } else {
    //     print("Clicked on notification");
    //   }
    // });


    // Listen to notification action streams
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction action) async {
        if (action.buttonKeyPressed == "REJECT") {
          print("Call rejected");
        } else if (action.buttonKeyPressed == "ACCEPT") {
          print("Call accepted");
        } else {
          print("Clicked on notification");
        }
      },
    );
  }

  @override
  void dispose() {
    AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                fcmToken = await FirebaseMessaging.instance.getToken();
                print("FCM Token: $fcmToken");
                if (fcmToken != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("FCM Token: $fcmToken")),
                  );
                }
              },
              child: const Text("Get FCM Token"),
            ),
            ElevatedButton(
              onPressed: () async{
                if (fcmToken != null) {
                  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
                  if(isAllowed){
                    sendPushNotification(fcmToken!);
                  }else{
                    await AwesomeNotifications().requestPermissionToSendNotifications();
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("FCM Token not available. Please get the token first.")),
                  );
                }
              },
              child: const Text("Send Push Notification"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPushNotification(String token) async {
    var accessToken = await PushNotificationServerKey.getAccessToken();
    print("*********************Bearer token : ${token}");
    print("*********************Access Bearer token : ${accessToken}");

    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/v1/projects/push-474fb/messages:send"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'message': {
              'notification': {
                'body': "Incoming call from John Doe",
                'title': 'Incoming Call',
              },
              'token': token,
            },
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }}





