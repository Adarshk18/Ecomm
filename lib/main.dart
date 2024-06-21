import 'package:eshopee/controllers/category_controller.dart';
import 'package:eshopee/views/screens/authentication_screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAPo4fc0UAd60OpCSLXmHBw64Ux5rSEx5w",
              appId: "1:308144131738:android:971948f6c053f297f01923",
              messagingSenderId: "308144131738",
              projectId: "eshopee-9cabf",
              storageBucket: "gs://eshopee-9cabf.appspot.com"),
        )
      : await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        initialBinding: BindingsBuilder(() {
          Get.put<CategoryController>(CategoryController());
        }));
  }
}
