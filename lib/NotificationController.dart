import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


// Background인 상황에서 메시지 컨트롤
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> messageData = message.data;
  print("_onBackgroundMessage: ${message.toMap()}");
}

class NotificationController extends GetxController {
  // 이렇게 하면 전역 static으로 어디서든 NotificationController.to.~~~로 접근 가능 예시: HomePage._incrementCounter에서 lastToken 접근
  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = Map<String, dynamic>().obs;
  String lastToken = '';

  @override
  void onInit() {
    _initNotification();
    _getToken();
    super.onInit();
  }

  // 토큰 요청해서 받아옴
  // @TODO 받아온 토큰을 서버에 전달하는 로직 추가 필요
  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      print(token);
      if(token != null) {
        lastToken = token;
      }
    } catch (e) {}
  }

  Future<void> _initNotification() async {
    _messaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /*
    // 버전이 올라가고 이렇게 설정하는게 안되고 아래처럼 각각 상황에 이벤트리스너들을 등록해줘야함
    _messaging.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
    );
     */

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      _onLaunch(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _onMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onResume(message);
    });
  }

  Future<void>? _onResume(RemoteMessage message) {
    Map<String, dynamic> data = message.data;
    print("_onResume: ${message.toMap()}");
    return null;
  }

  // 백그라운드에서 온 메시지로 Notification이 표시되었을 때 누르면 실행이 되기도 하는 부분..
  Future<void>? _onLaunch(RemoteMessage? message) {
    if(message != null) {
      Map<String, dynamic>? data = message.data;
      print("_onLaunch: ${message.toMap()}");
      _actionOnNotification(data);
    }
    return null;
  }

  void _actionOnNotification(Map<String, dynamic>? messageMap) {
    message(messageMap);
  }

  // 앱이 열려있을 때 메시지 수신 시 실행되는 부분
  Future<void>? _onMessage(RemoteMessage message) {
    Map<String, dynamic> data = message.data;
    print("_onMessage: ${message.toMap()}");
    // Foreground 수신시 Notification display(https://velog.io/@adbr/flutter-local-notification-Quick-Start2#3-maindart-init-settings 참고)
    buildNotification(message);
    return null;
  }

  void buildNotification(RemoteMessage message) async {
    final notiTitle = message.notification!.title;
    final notiBody = message.notification!.body;

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /*final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );*/

    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel id',
      'channel_name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, notiTitle, notiBody, platformChannelSpecifics,
        payload: 'item x');

    // var ios = IOSNotificationDetails();
    // var detail = NotificationDetails(android: android, iOS: ios);

    /*
    if (result != null && result) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // id는 unique해야합니다. int값
        notiTitle,
        notiDesc,
        _setNotiTime(),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
     */
  }

  tz.TZDateTime _setNotiTime() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        0, 0, 5);

    return scheduledDate;
  }
}

/*
// 메시지 포맷
{
  senderId: null, category: null, collapseKey: com.ri.poc.poc,
  contentAvailable: false, data: {test: 7}, from: 199119672202,
  messageId: 0:1651122598412218%f639d570f639d570, messageType: null,
  mutableContent: false,
  notification: {
    title: forward msg 7, titleLocArgs: [], titleLocKey: null, body: 테스트,
    bodyLocArgs: [], bodyLocKey: null,
    android: {
      channelId: null, clickAction: null,
      color: null, count: null, imageUrl: https://cdn.aflnews.co.kr/news/photo/201612/125752_8499_3111.jpg,
      link: null, priority: 0, smallIcon: null,
      sound: null, ticker: null, tag: campaign_collapse_key_6366358034051295872, visibility: 0
    },
    apple: null, web: null
  }, sentTime: 1651122421998, threadId: null, ttl: 2419200
}
*/