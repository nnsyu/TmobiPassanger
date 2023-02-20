import 'package:flutter/material.dart';
import 'package:tmobi_passenger/screens/login/login_srceen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    //_loading();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('티모비 승객용'),
          )
        ],
      ),
    );
  }

  _loading() async {
    await Future.delayed(const Duration(
      seconds: 2,
    ),);

    Navigator.pushNamed(context, '/login');
  }
}
