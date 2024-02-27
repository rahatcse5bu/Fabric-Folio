import 'dart:convert';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/colors.dart';
import 'package:elegant_notification/elegant_notification.dart';

import 'addCustomer.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class Customer {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerLocation;

  Customer({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerLocation,
  });
}

class _CustomersState extends State<Customers> {
  List<Customer> filteredCustomers = [];
  List<Customer> customers = [];
  // List<Map<String, dynamic>> customers = [];
  TextEditingController _searchController = TextEditingController();

//my variables starts

  String selectedCustomerId = '64ae9f6d559978be96f6c33b';
  String _selectedCustomer = 'Sujan';

  //my variables ends
  Future<List<Customer>> fetchCustomers() async {
            LocalStorageInterface prefs = await LocalStorage.getInstance();
     String? user_id= prefs.getString('user_id');
    final response = await http.get(
        Uri.parse('https://fabric-folio.vercel.app/api/customers/all/'+user_id.toString()));
    if (response.statusCode == 200 || response.statusCode == 202) {
      final jsonData = jsonDecode(response.body);
      List<Customer> customerList = [];
      for (var customer in jsonData['data']) {
        customerList.add(
          Customer(
            id: customer['_id'],
            customerName: customer['customerName'],
            customerPhone: customer['customerPhone'],
            customerLocation: customer['customerLocation'],
          ),
        );
      }

      return customerList;
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
        filteredCustomers = value;
      });
    });
  }

  Future<void> deleteCustomer(String id) async {
    final url = 'https://fabric-folio.vercel.app/api/customers/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        customers.removeWhere((customer) => customer.id == id);
        ElegantNotification.error(
                title: Text("Deleted"),
                description: Text("The Customer has been Deleted"))
            .show(context);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchCustomers(String searchQuery) {
    setState(() {
      // print("searching. " + searchQuery);
      if (searchQuery.isEmpty) {
        // If search query is empty, display all orders
        filteredCustomers = List.from(customers);
        // orders = orders;
      } else {
        filteredCustomers = customers
            .where((customer) =>
                customer.customerLocation
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                customer.customerPhone.contains(searchQuery) ||
                customer.customerName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        centerTitle: true,
        backgroundColor: GlobalVariables.primaryColor,
        leading: null,
      ),
      body: Container(
        color: Colors.grey[250],
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                searchCustomers(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Customer by Name, Phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 10),
            filteredCustomers.length <= 0
                ? Center(child: Text("No Customers Found"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => orderDetails(
                            //       orderId: customer.id,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: Card(
                              elevation: 7.2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  // Divider(
                                  //   color: GlobalVariables.primaryColor,
                                  //   thickness: 3,
                                  // ),
                                  ListTile(
                                    tileColor: Colors.white,
                                    leading: Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        // color: GlobalVariables.primaryColor,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              GlobalVariables.primaryColor,
                                          child: Text(
                                            customer.customerName[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )),
                                    title: Text(
                                      customer.customerName,
                                      // order.clothName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      customer.customerPhone +
                                          "\n[" +
                                          customer.customerLocation +
                                          "]\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: Text('Edit'),
                                          value: 'edit',
                                        ),
                                        PopupMenuItem(
                                          child: Text('Delete'),
                                          value: 'delete',
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          // Implement edit functionality
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => editCustomer(
                                          //       orderId: customer.id,
                                          //     ),
                                          //   ),
                                          // );
                                        } else if (value == 'delete') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Deletion'),
                                                content: Text(
                                                    'Are you sure you want to delete this customer?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      deleteCustomer(
                                                          customer.id);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalVariables.primaryColor,
        onPressed: () {
          // material page route
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => addCustomer(),
          ));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
