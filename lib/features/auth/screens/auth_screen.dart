// ignore_for_file: prefer_final_fields, prefer_const_constructors, unused_field

import 'dart:async';
import 'dart:developer';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:nuriya_tailers/common/custom_button.dart';
import 'package:nuriya_tailers/features/auth/screens/Register.dart';
import 'package:nuriya_tailers/features/auth/services/auth_services.dart';

import '../../../Navbar/navbar.dart';
import '../../../common/custom_textfield.dart';
import '../../../constants/colors.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signin;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   bool isloading= false;
  @override
  void initState() {
    super.initState();
    // initLocalStorageAndRedirect();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<void> signInUser() async {
    authService.signInUser(
        context: context,
        password: _passwordController.text,
        userName: _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          // flexibleSpace: Container(
          //   decoration:
          //       const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          // ),
          backgroundColor: GlobalVariables.primaryColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Center(child: Text('Fabric-Folio', style: TextStyle(color: Colors.white)),
                  
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(31, 9, 237, 16), width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    //color: Color.fromARGB(255, 25, 16, 16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, top: 40, right: 20, bottom: 40),
                        color: GlobalVariables.backgroundColor,
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    border: Border.all(
                                        color: GlobalVariables.primaryColor,
                                        width: 1.5),
                                    color: GlobalVariables.primaryColor),
                                padding: const EdgeInsets.only(
                                    bottom: 15, top: 15, left: 20, right: 20),
                                // color: GlobalVariables.primaryColor,
                                child: Center(
                                  child: Text(
                                    "Login Here",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                                key: _signInFormKey,
                                child: Column(
                                  children: [
                                    CutsomTextField(
                                      controller: _usernameController,
                                      hintText: 'Username',
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CutsomTextField(
                                      controller: _passwordController,
                                      hintText: 'Password',
                                      isObsure: true,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomButton(
                                        text: 'Sign In',
                                        isLoading:isloading,
                                        onTap: () {
                                               setState(() {
                                      isloading=true;
                                });
                                          signInUser();
                                        }),
                                        
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                              TextButton(
                              onPressed: () {
                                //material navigation to previous page
                            
                           
                                Timer(
                                    const Duration(seconds: 1),
                                    () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Register())));
                           
                              },
                              child: Text('Create an Account'),
                            ),
                                          ],
                                        )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
