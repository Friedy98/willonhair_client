
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_services.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class SplashView extends GetView<AuthController>{

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen.withScreenFunction(
      splash: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/img/photo_2022-11-25_01-12-07.jpg",
              fit: BoxFit.contain, width: double.infinity, height: double.infinity),
          Positioned(
            bottom: 30,
            child: Text(
              'Package Info v${Domain.packageInfo.version}',  // Your package info text
              style: TextStyle(
                color: Colors.grey, // choose a contrasting color
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      duration: 5000,
      splashIconSize: double.infinity,
      screenFunction: () async{
        return LoginView();
      },
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
      //pageTransitionType: PageTransitionType.scale,
    );
  }
}