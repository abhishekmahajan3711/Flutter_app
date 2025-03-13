import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'product_screen.dart';
import 'counter_screen.dart';
import 'theme_controller.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: Platform.isAndroid || Platform.isIOS
        ? null  // Mobile uses default Firebase config
        : "815084086465-jnhp9sls61vahh7b32hq46omv690t5nv.apps.googleusercontent.com", // Required for Web
  );

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) return null; // User canceled the sign-in

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAyMmTGX4EeE8YiR40FEWhKjrSeAqxS2oA",
      authDomain: "flutter1-de81c.firebaseapp.com",
      projectId: "flutter1-de81c",
      storageBucket: "flutter1-de81c.firebasestorage.app",
      messagingSenderId: "815084086465",
      appId: "1:815084086465:web:7b49925317fa9b35012040",
      measurementId: "G-4TJEC0KB9X",
    ),
  );
  }else{
    await Firebase.initializeApp();
  }
  
  Get.put(ThemeController()); // Initialize ThemeController
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.themeMode.value,
          home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomeScreen(),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), actions: [
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: () => themeController.toggleTheme(),
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(() => LoginScreen());
          },
        )
      ]),
      body: Column(children: [Expanded(child: ProductScreen()), CounterScreen()]),
    );
  }
}
