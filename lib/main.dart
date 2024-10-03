import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:push_notifications/firebase_options.dart';

Future<void> backGroundHandler(RemoteMessage message)async{
  String? title = message.notification?.title;
  String? body = message.notification?.body;

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 123,
          channelKey: "Call_Channel",
        color: Colors.white,
        title: title,
        body: body,
        category:  NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        backgroundColor: Colors.orange
       ),
    actionButtons: [
      NotificationActionButton(key: "REJECT", label: "reject Call",
          color: Colors.green,
          autoDismissible: true),

      NotificationActionButton(key: "ACCEPT", label: "Acccep Call",
          color: Colors.green,
          autoDismissible: true)
    ]

  );
}

void main() async{

  AwesomeNotifications().initialize(
      null, [
        NotificationChannel(
            channelKey: "Call_Channel",
            channelName: "Call_Channel",
            channelDescription: "Channel of Calling",
          defaultColor: Colors.green,
          ledColor: Colors.white,
           importance: NotificationImportance.Max,
           channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone
        )
  ]);
  FirebaseMessaging.onBackgroundMessage(backGroundHandler);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen()
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message){

      String? title = message.notification?.title;
      String? body = message.notification?.body;
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 123,
              channelKey: "Call_Channel",
              color: Colors.white,
              title: title,
              body: body,
              category:  NotificationCategory.Call,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: Colors.orange
          ),
          actionButtons: [
            NotificationActionButton(key: "REJECT", label: "reject Call",
                color: Colors.green,
                autoDismissible: true),

            NotificationActionButton(key: "ACCEPT", label: "Acccep Call",
                color: Colors.green,
                autoDismissible: true)
          ]

      );

      AwesomeNotifications().actionStream.listen((event){
        if(event.buttonKeyPressed == "REJECT"){
          print("call rejected");
        }else if(event.buttonKeyPressed == "ACCEPT"){
          print("call is accept");
        }else{
          print("clicked on notification");
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: ()async{
                String? token = await FirebaseMessaging.instance.getToken();
                print("=========token fcm ${token}");
              },
              child: Text("Get Token"),
            ),


            InkWell(
              onTap: (){},
              child: Text("Get Token"),
            )
          ],
        ),
      ),
    );
  }


  Future<void> sendPushNotification() async {
    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=somethink here"',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "body will here",
              'title': 'Nueva Solicitud',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': "authorizedSupplierTokenId will be here",
            'token': "authorizedSupplierTokenId will be here"
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
}



