import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmobi_passenger/providers/auth_provider.dart';
import 'package:tmobi_passenger/screens/login/login_srceen.dart';
import 'package:tmobi_passenger/screens/service/firebase_manager.dart';
import 'package:tmobi_passenger/screens/service/routes.dart';
import 'package:tmobi_passenger/screens/splash/screen_splash.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseManager.initializeDefault();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
