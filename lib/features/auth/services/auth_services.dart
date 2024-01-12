// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/Dashboard/dashboard.dart';
import 'package:nuriya_tailers/Navbar/navbar.dart';
import 'package:nuriya_tailers/Orders/OrdersOld.dart';
import 'package:nuriya_tailers/constants/error_handling.dart';
import 'package:nuriya_tailers/constants/utils.dart';
import 'package:cross_local_storage/cross_local_storage.dart';

class AuthService {
  // sign up user
  void signInUser({
    required BuildContext context,
    required String userName,
    required String password,
  }) async {
    try {
      LocalStorageInterface prefs = await LocalStorage.getInstance();
      // prefs.setBool("isLoggedd", false);
        prefs.setString('username', 'notLogged');
        prefs.setString('user_id', 'null');
      http.Response res = await http.post(
        Uri.parse('https://fabric-folio.vercel.app/api/auth/login'),
        body: jsonEncode({
          "username": userName,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      inspect(res);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('apiToken', 'logIn');
          // prefs.setBool("isLoggedd", true);
          prefs.setString('username', 'Logged');
          var responseBody = jsonDecode(res.body);
          print(responseBody['_id'].toString());
          prefs.setString('user_id', responseBody['_id']);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NavbarScreen()));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
