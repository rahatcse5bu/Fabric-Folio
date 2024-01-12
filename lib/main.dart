// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'dart:async';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';
import 'package:nuriya_tailers/features/auth/screens/Register.dart';
import 'package:nuriya_tailers/features/auth/screens/auth_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'Navbar/navbar.dart';
import 'Orders/addOrder.dart';
import 'Orders/Orders.dart';

void main() {
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      // home: Register(),
      // home: addOrderNew(),
      // home: Orders(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  void initLocalStorageAndRedirect() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    // prefs.setBool("isLogged", false);
    //  print( prefs.getString('username'));
    // print(prefs.getBool('isLoggedd'));
  //    Timer(
  //         const Duration(seconds: 5),
  //         () async =>  {
  //               print("after 5 "+prefs.getBool('isLoggedd').toString()),
  //                 print( "5 nhnjhu=> "+prefs.getString('username').toString()),
  //   if (await prefs.getBool('isLoggedd') == false || await prefs.getBool('isLoggedd') == null) {
  //     Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => const AuthScreen()))
     
  //   } else {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const NavbarScreen()))
  //   }
  // }
  //    );
      Timer(
        const Duration(seconds: 5),
        () async => {
              // print("after 5 " + prefs.getBool('isLoggedd').toString()),
              // print("5 nhnjhu=> " + prefs.getString('username').toString()),
              if ( prefs.getString('username') == 'notLogged' ||
                   prefs.getString('username') == null)
                {
                  // print("sabuj"),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()))
                }
              else
                {
                  // print("rahatttt"),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavbarScreen()))
                }
            });
  }
  @override
  void initState() {
    super.initState();
    initLocalStorageAndRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: GlobalVariables.primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'নুরিয়া পাঞ্জাবি টেইলার্স এন্ড ফেব্রিকস',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'মাদ্রাসা পাড়া, আশ্রাফাবাদ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'কামরাঙ্গীর চর, ঢাকা',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Developed by: PNC Soft Tech',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email:pncsofttechmail@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Phone: 01793278360',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: GlobalVariables.backgroundColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 140,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,

                  /// Required, The loading type of the widget
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.blue,
                    Colors.orange,
                    Colors.green,
                    Colors.indigo,
                    Colors.purple,
                  ],

                  /// Optional, The color collections
                  strokeWidth: 1,
                ),
              )
            ],
          ),
        ));
  }
}
