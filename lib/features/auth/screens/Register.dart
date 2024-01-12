import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nuriya_tailers/features/auth/screens/auth_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController shopController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> registerShop(String username, String email, String password,
        String shopname, String name) async {
      var url = Uri.parse('https://fabric-folio.vercel.app/api/auth/');
      try {
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'email': email,
            'password': password,
            'shopName': shopname,
            'name': name,
          }),
        );

        if (response.statusCode == 201) {
          // Handle the response
          print('Shop Registered successfully');
          Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) =>
              const AuthScreen()));
        } else {
          // Handle the error
          print('Failed to register Shop. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
   
        // decoration: BoxDecoration(border: Border.symmetric(horizontal: 10, vertical: 10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Your Name"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: shopController,
              decoration: InputDecoration(labelText: "Shop Name"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  print(usernameController.text);
                              registerShop(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    shopController.text,
                    nameController.text);
                },
                child: Text("Register")),
            TextButton(
              onPressed: () {
                registerShop(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    shopController.text,
                    nameController.text);
              },
              child: Text("Already Have an account? Login Here"),
            )
          ],
        ),
      ),
    );
  }
}
