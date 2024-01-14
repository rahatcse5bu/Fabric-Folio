import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/colors.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isLoading = false;
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
          setState(() {
            isLoading = false;
          });
          print('Shop Registered successfully');
          Fluttertoast.showToast(
              msg: "Shop Registered successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: GlobalVariables.primaryColor,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthScreen()));
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg:
                  'Failed to register Shop. Status code: ${response.statusCode}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // Handle the error
          print('Failed to register Shop. Status code: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Failed to register Shop. Error: $e',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: Text('Register Shop', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        // decoration: BoxDecoration(border: Border.symmetric(horizontal: 10, vertical: 10)),
        decoration: BoxDecoration(
          // boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * .95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Colors.white60),
          padding:
              const EdgeInsets.only(bottom: 15, top: 15, left: 20, right: 20),
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
              isLoading
                  ? CircularProgressIndicator(
                      color: GlobalVariables.primaryColor,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        // print(usernameController.text);
                        setState(() {
                          isLoading = true;
                        });
                        registerShop(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                            shopController.text,
                            nameController.text);
                      },
                      child: Text("Register",
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                          maximumSize: MaterialStateProperty.all<Size>(
                              Size.fromHeight(50)),
                          backgroundColor: MaterialStatePropertyAll(
                              GlobalVariables.primaryColor)),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                },
                child: Text("Already Have an account? Login Here"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
