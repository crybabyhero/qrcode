import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/auth_controller.dart';
import 'package:qrcode/app/modules/loadingscreen/loading_screen.dart';
import 'package:qrcode/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (contextm, snapAuth) {
        if (snapAuth.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "QR Code",
          initialRoute: snapAuth.data != null ? Routes.home : Routes.login,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
