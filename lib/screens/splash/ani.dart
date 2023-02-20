import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmobi_passenger/screens/login/login_srceen.dart';
import 'package:tmobi_passenger/screens/splash/screen_splash.dart';

class MyCustomWidget extends StatefulWidget {
  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation scaleAnimation;
  late Animation opacityAnimation;


  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.push(
              context,
              AnimatingRoute(
                page: widget,
                route: LoginScreen(),
              ),
            );
          }
        },
      );

    // scaleAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(scaleController);
    scaleAnimation = Tween(begin: 1.0, end: 20.0).animate(animationController);
    opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(animationController);

    _loading();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: scaleAnimation,
          builder: (c, child) => Transform.scale(
            scale: scaleAnimation.value,
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Image.asset(
                'assets/images/tmap_logo.png',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }



  _loading() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    animationController.forward();
    //Navigator.pushNamed(context, '/login');
  }
}

class AnimatingRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  AnimatingRoute({required this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: route,
          ),
        );
}
