import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flt_b2b_easy_pay/pages/HomePage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'NotificationController.dart';

void main() async {
  // 비동기로 데이터들이 준비가 되고 runApp 메소드가 실행되도록 하는 코드
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Firebase 초기화
  await Firebase.initializeApp();

  _initAwesomeNotification();

  _initAfterPagnation();  // 스플래시 화면에서 확인하거나 초기화해야하는 작업 처리

  runApp(const MyApp());
}

void _initAfterPagnation() {
  // 처리가 완료되면 스플래시를 닫음
  FlutterNativeSplash.remove();
}

void _initAwesomeNotification() {
  AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  AwesomeNotifications().actionStream.listen(
          (ReceivedNotification receivedNotification){
        print("_onAwesomeNotificationsActionStream: $receivedNotification");
        /*Navigator.of(context).pushNamed(
            '/NotificationPage',
            arguments: {
              // your page params. I recommend you to pass the
              // entire *receivedNotification* object
              id: receivedNotification.id
            }
        );*/
      }
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //
      initialBinding: BindingsBuilder(
            () {
          Get.put(NotificationController());
        },
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage(title: 'Flutter Demo Home Page',)),
        /* GetPage(name: '/second', page: () => Second()),
        GetPage(
            name: '/third',
            page: () => Third(),
            transition: Transition.zoom
        ),*/
      ],
      //home: const MyHomePage(title: ),
    );
  }
}
