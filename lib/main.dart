import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'app/models/notification_model.dart';
import 'app/providers/firebase_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/api_services.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DefaultFirebaseOptions.currentPlatform;

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }

  final remoteModel = NotificationModel(
    title: message.notification?.title.toString(),
    id: message.messageId.toString(),
    isSeen: false,
    message: message.notification?.body.toString(),
    timestamp: message.sentTime.toString(),
    disable: false,
  );

  await Hive.initFlutter();
  if (Hive.isBoxOpen('backgroundMessage')) {
    await Hive.box('backgroundMessage').close();
  }

  await Hive.openBox('backgroundMessage');
  final bgBox = Hive.box("backgroundMessage");
  bgBox.add(remoteModel.toJson());
  bgBox.close();

}
 AndroidNotificationChannel channel;

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initServices() async {
  Get.log('starting services ...');

  await GetStorage.init();
  await Get.putAsync(() => GlobalService().init());
  //await Firebase.initializeApp();
  /*if (Firebase.apps.isEmpty) {
    Firebase.initializeApp();
  } else {
    Firebase.app();
  }// if already initialized, use that one
  */
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  //await Get.putAsync(() => TranslationService().init());
  Get.log('All services started...');

  final box = GetStorage();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; }}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    name: 'willonhair-v3',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();

   await Hive.initFlutter();
   await Hive.openBox('myBox');
   await Hive.openBox('notifications');


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        "high_importance_channel", 'High Importance Notifications');
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(
    GetMaterialApp(
      title: Domain.AppName,
      initialRoute: Theme1AppPages.INITIAL,
      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      getPages: Theme1AppPages.routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      //supportedLocales: Get.find<TranslationService>().supportedLocales(),
      //translationsKeys: Get.find<TranslationService>().translations,
      //locale: Get.find<TranslationService>().getLocale(),
      //fallbackLocale: Get.find<TranslationService>().getLocale(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  ));
}
