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

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // Successful response
      var responseBody = jsonDecode(res.body);

      if(responseBody.containsKey('_id') && responseBody['_id'] != null) {
        // Valid response with user_id
        await prefs.setString('apiToken', 'logIn');
        prefs.setString('username', 'Logged');
        prefs.setString('user_id', responseBody['_id'].toString());

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NavbarScreen()));
      } else {
        // Handle invalid response
        showSnackBar(context, "Invalid response: User ID not found");
      }
    } else {
      // Handle error response
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

}
