import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/content_pages/accessContent.dart';
import 'package:moodle/viewProfile.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:moodle/sidebar_pages/home_pages/home.dart';
import 'package:moodle/login_pages/login.dart';
import 'package:moodle/login_pages/authPage.dart';
import 'package:moodle/register_pages/register.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/myCourses.dart';
import 'package:moodle/sidebar_pages/home_pages/addSemester.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/addCourse.dart';
import 'package:moodle/sidebar_pages/certificate_pages/addCertificate.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/content_pages/content.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/content_pages/addContent.dart';
import 'package:moodle/courseIdModel.dart';
import 'package:moodle/notifications.dart';
import 'package:moodle/addNotification.dart';
import 'package:moodle/sidebar_pages/certificate_pages/downloadCertificate.dart';
import 'package:moodle/sidebar_pages/grades_pages/addGrades.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => CourseIdModel(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: 'authPage',
      routes: {
        'authPage': (context)=> AuthPage(),
        'login': (context)=> Login(),
        'register': (context)=> Register(),
        'home': (context)=> Home(),
        'myCourses': (context)=> MyCourses(),
        'addSemester': (context)=> AddSemester(),
        'addCourse': (context)=> AddCourse(),
        'addCertificate': (context)=> AddCertificate(),
        'content': (context)=> Content(),
        'addContent': (context)=> AddContent(),
        'notifications': (context)=> Notifications(),
        'addNotification': (context)=> AddNotification(),
        'addGrades': (context)=> AddGrades(),
        'viewProfile': (context)=> ViewProfile()
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'downloadCertificate') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => DownloadCertificate(
              certificateUrl: args['certificateUrl']!,
              certificateName: args['certificateName']!,
            ),
          );
        }
        else if (settings.name == 'accessContent') {
          final args = settings.arguments as Map<String, String?>;
          return MaterialPageRoute(
            builder: (context) => AccessContent(
                conTitle: args['conTitle']!,
                courseId: args['courseId']!,
            ),
          );
        }
        throw Exception('Unknown route: ${settings.name}');
      },
    ),
  ));
}
