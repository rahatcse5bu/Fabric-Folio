import 'dart:convert';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import 'Customers.dart';
import 'package:dropdown_search/dropdown_search.dart';

class addCustomer extends StatefulWidget {
  const addCustomer({super.key});

  @override
  State<addCustomer> createState() => _addCustomerState();
}

class _addCustomerState extends State<addCustomer> {
  List<Map<String, dynamic>> customers = [];
// String selectedCustomerId = '';
//my variables starts
  final _formKey = GlobalKey<FormState>();
  String selectedCustomerId = '64ae9f6d559978be96f6c33b';
  String _selectedCustomer = 'Sujan';

  //my variables ends
  var updatedCustomerName = 'Error';
  String _customerName = '';
  String _customerPhone = '';
  String _customerLocation = '';

  Future<String> addNewCustomer(
    String customerName,
    String customerPhone,
    String customerLocation,
  ) async {
         LocalStorageInterface prefs = await LocalStorage.getInstance();
     String? user_id= prefs.getString('user_id');
    final url = 'https://fabric-folio.vercel.app/api/customers/';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'user': user_id,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerLocation': customerLocation,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    var myJSON = jsonEncode({
       'user': user_id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerLocation': customerLocation,
    });
    // print(customerId + "Cust IDDDDDDD");
    // print(myJSON.toString());
    if (response.statusCode == 200) {
      // id = jsonDecode(response.body)['_id'];
      print(jsonDecode(response.body));
      updatedCustomerName = jsonDecode(response.body)['data']['customerName'];
      // print("Order Id: $orderId");

      return updatedCustomerName;
    } else {
      print("Error: " + response.statusCode.toString());
      return 'error';
    }
  }

  Future<List<Map<String, dynamic>>> fetchCustomers() async {
             LocalStorageInterface prefs = await LocalStorage.getInstance();
     String? user_id= prefs.getString('user_id');
    final response = await http.get(
        Uri.parse('https://fabric-folio.vercel.app/api/customers/all/'+user_id.toString()));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text('Add Customer'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'কাস্টমারের নাম',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a customer name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _customerName = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'কাস্টমারের ফোন নাম্বার',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a customer phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _customerPhone = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'কাস্টমারের ঠিকানা',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a customer location';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _customerLocation = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //Elevated button for submit
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        //width of button

                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20), backgroundColor: GlobalVariables.primaryColor,
                          // onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Customer Adding...'),
                                content:
                                    // Text(
                                    //     'Order (${snapshot.data})  Created Successfully'),
                                    FutureBuilder<String>(
                                        future: addNewCustomer(_customerName,
                                            _customerPhone, _customerLocation),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                )); // Show a loading indicator while waiting for the result
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}'); // Show an error message if an error occurred
                                          } else {
                                            String order_ID = snapshot.data ??
                                                "Error"; // Retrieve the result from the snapshot
                                            return Text(
                                                ' Customer ${updatedCustomerName} Added Successfully ',
                                                style: TextStyle(fontSize: 13));
                                          }
                                        }),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      //material navigation to previous page
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Customers()),
                                        );
                                      });
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );

                          // Navigator.of(context).pop();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => Orders()),
                          // );
                        },
                        child: Text('Add Customer'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
