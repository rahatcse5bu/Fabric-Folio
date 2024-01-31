import 'dart:convert';

import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/Orders/addOrder.dart';
import 'package:nuriya_tailers/constants/colors.dart';

import 'editOrder.dart';
import 'orderDetails.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class Order {
  final String id;
  final String orderId;
  final String orderNote;
  final String customerName;
  final String customerPhone;
  final String customerLocation;
  final String orderStatus;
  final int paidAmount;
  final String estimatedDeliveryTime;
  final List<Map<String, dynamic>> clothList;

  Order({
    required this.id,
    required this.orderId,
    required this.orderNote,
    required this.customerName,
    required this.customerPhone,
    required this.customerLocation,
    required this.paidAmount,
    required this.estimatedDeliveryTime,
    required this.orderStatus,
    required this.clothList,
  });
}
class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String password;
  final String shopName;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.shopName,
  });
}

// class Customer {
//   final String id;
//   final String customerName;
//   final String customerPhone;
//   final String customerLocation;

//   Customer({
//     required this.id,
//     required this.customerName,
//     required this.customerPhone,
//     required this.customerLocation,
//   });
// }

class _OrdersState extends State<Orders> {
  List<Order> orders = [];
  List<User> userDetails = [];
  List<Order> filteredOrders = [];
  List<Map<String, dynamic>> clothList = [];
  List<Map<String, dynamic>> customers = [];
  TextEditingController _searchController = TextEditingController();

//my variables starts
  bool isLoading = true;
  String selectedCustomerId = '64ae9f6d559978be96f6c33b';
  String _selectedCustomer = 'Sujan';

  //my variables ends
  Future<List<Order>> fetchOrders() async {
              LocalStorageInterface prefs = await LocalStorage.getInstance();
              String? u_id = prefs.getString('user_id');
    final response = await http.get(
        // Uri.parse('https://nuriya-tailers-backend.vercel.app/api/orders/'));
        Uri.parse('https://fabric-folio.vercel.app/api/orders/users/$u_id'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Order> orderList = [];
      for (var order in jsonData['data']) {
        orderList.add(Order(
          id: order['_id'],
          orderId: order['orderId'],
          orderNote: order['orderNote'],
          customerName: order['customerName'] ?? '',
          customerPhone: order['customerPhone'] ?? '',
          customerLocation: order['customerLocation'] ?? '',
          orderStatus: order['orderStatus'],
          paidAmount: order['paidAmount'],
          estimatedDeliveryTime: order['estimatedDeliveryTime'],
          clothList: [],
          // customer: Customer(
          //   id: order['customerId']['_id'],
          //   customerName: order['customerId']['customerName'],
          //   customerPhone: order['customerId']['customerPhone'],
          //   customerLocation: order['customerId']['customerLocation'],
          // ),
        ));
      }
      return orderList;
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
Future<List<User>> fetchUserDetails() async {
              LocalStorageInterface prefs = await LocalStorage.getInstance();
              String? u_id = prefs.getString('user_id');
    final response = await http.get(
        // Uri.parse('https://nuriya-tailers-backend.vercel.app/api/orders/'));
        Uri.parse('https://fabric-folio.vercel.app/api/users/$u_id'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<User> userDetails = [];
      for (var order in jsonData['data']) {
        userDetails.add(User(
          id: order['_id'],
          username: order['username'],
          name: order['name'],
          email: order['email'] ?? '',
          password: order['password'] ?? '',
          shopName: order['shopName'] ?? '',
       
        ));
      }
      return userDetails;
    } else {
      throw Exception('Failed to fetch User details');
    }
  }
  @override
  void initState() {
    super.initState();

    fetchUserDetails().then((value) {
      setState(() {
   userDetails = value;
        print(userDetails);
      });
    });

        fetchOrders().then((value) {
      setState(() {
        isLoading = false;
        orders = value;
        filteredOrders = value;
        // print(filteredOrders);
      });
    });
  }

  Future<void> deleteOrder(String id) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        orders.removeWhere((order) => order.id == id);
        ElegantNotification.error(
                title: Text("Deleted"),
                description: Text("The Order has been Deleted"))
            .show(context);
      });
    }
  }

  var orderId;

  Future<void> createOrder(
    String customerId,
    String orderNote,
    String clothName,
    String clothType,
    double price,
    DateTime estimatedDeliveryTime,
    String lomba,
    String payerMuhri,
    String hatarMuhri,
    String hiegh,
    String puut,
    String bodyy,
    String hata,
    String kolarToyri,
    String komor,
    bool isPoket,
    bool isTwoPocketChain,
    bool isChain,
    bool isMotaShuta,
    bool isDoubleSelai,
    bool isMotaRabar,
    bool is2Pocket,
    bool isMobilePocket,
    bool isBendRoundColar,
    bool isKotiColar,
    bool isDoublePlate,
    bool isRoundcolar,
    bool isSinglePlate,
    bool isFull,
    bool isSamna,
    bool isColar,
    bool isMura,
    bool isHata,
    bool isKop,
    bool isSidePocket,
    bool isKandi,
    bool isFullBodySita,
    bool isColarSingle,
    bool isColarDouble,
    bool isSamnaSita,
    bool isGolGola,
    bool isOneChain,
    bool isOneGuntiDana,
    bool is3GuntiDana,
  ) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'customerId': customerId,
        'orderNote': orderNote,
        'clothName': clothName,
        'clothType': clothType,
        'price': price,
        'totalPrice': price,
        'estimatedDeliveryTime': estimatedDeliveryTime.toIso8601String(),
        'lomba': lomba,
        'payerMuhri': payerMuhri,
        'hatarMuhri': hatarMuhri,
        'hiegh': hiegh,
        'puut': puut,
        'body': bodyy,
        'hata': hata,
        'kolarToyri': kolarToyri,
        'komor': komor,
        'isPoket': isPoket,
        'isTwoPocketChain': isTwoPocketChain,
        'isChain': isChain,
        'isMotaShuta': isMotaShuta,
        'isDoubleSelai': isDoubleSelai,
        'isMotaRabar': isMotaRabar,
        'is2Pocket': is2Pocket,
        'isMobilePocket': isMobilePocket,
        'isBendRoundColar': isBendRoundColar,
        'isKotiColar': isKotiColar,
        'isDoublePlate': isDoublePlate,
        'isRoundcolar': isRoundcolar,
        'isSinglePlate': isSinglePlate,
        'isFull': isFull,
        'isSamna': isSamna,
        'isColar': isColar,
        'isMura': isMura,
        'isHata': isHata,
        'isKop': isKop,
        'isSidePocket': isSidePocket,
        'isKandi': isKandi,
        'isFullBodySita': isFullBodySita,
        'isColarSingle': isColarSingle,
        'isColarDouble': isColarDouble,
        'isSamnaSita': isSamnaSita,
        'isGolGola': isGolGola,
        'isOneChain': isOneChain,
        'isOneGuntiDana': isOneGuntiDana,
        'is3GuntiDana': is3GuntiDana,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    // var myjson = jsonEncode({
    //   'customerId': customerId,
    //   'orderNote': orderNote,
    //   'clothName': clothName,
    //   'clothType': clothType,
    //   'price': price,
    //   'totalPrice': price,
    //   'estimatedDeliveryTime': estimatedDeliveryTime.toIso8601String(),
    //   'lomba': lomba,
    //   'payerMuhri': payerMuhri,
    //   'hatarMuhri': hatarMuhri,
    //   'hiegh': hiegh,
    //   'puut': puut,
    //   'body': bodyy,
    //   'hata': hata,
    //   'kolarToyri': kolarToyri,
    //   'komor': komor,
    //   'isPoket': isPoket,
    //   'isChain': isChain,
    //   'isMotaShuta': isMotaShuta,
    //   'isDoubleSelai': isDoubleSelai,
    //   'isMotaRabar': isMotaRabar,
    //   'is2Pocket': is2Pocket,
    //   'isMobilePocket': isMobilePocket,
    //   'isBendRoundColar': isBendRoundColar,
    //   'isKotiColar': isKotiColar,
    //   'isDoublePlate': isDoublePlate,
    //   'isRoundcolar': isRoundcolar,
    //   'isSinglePlate': isSinglePlate,
    //   'isFull': isFull,
    //   'isSamna': isSamna,
    //   'isColar': isColar,
    //   'isMura': isMura,
    //   'isHata': isHata,
    //   'isKop': isKop,
    //   'isSidePocket': isSidePocket,
    //   'isKandi': isKandi,
    //   'isFullBodySita': isFullBodySita,
    //   'isColarSingle': isColarSingle,
    //   'isColarDouble': isColarDouble,
    //   'isSamnaSita': isSamnaSita,
    //   'isGolGola': isGolGola,
    //   'isOneChain': isOneChain,
    //   'isOneGuntiDana': isOneGuntiDana,
    //   'is3GuntiDana': is3GuntiDana,
    //   'orderStatus': 'pending',
    // });

    if (response.statusCode == 200) {
      // id = jsonDecode(response.body)['_id'];
      orderId = jsonDecode(response.body)['orderId'];
      // print("Order Id: $orderId");
      setState(() {});
    } else {
      print("Error: " + response.statusCode.toString());
    }
  }

  Future<void> markAsDelivered(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';
    final body = jsonEncode({'orderStatus': 'delivered'});

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        // print('Order marked as delivered successfully.');

        fetchOrders().then((value) {
          setState(() {
            isLoading = false;
            orders = value;
            filteredOrders = value;
            ElegantNotification.success(
                    title: Text("Delivered"),
                    description: Text("The Order has been marked as Delivered"))
                .show(context);
          });
        });

        // Handle success scenario
      } else {
        // Handle error scenario
      }
    } catch (error) {
      // Handle error scenario
    }
  }

  Future<void> markAsDone(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';
    final body = jsonEncode({'orderStatus': 'done'});

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        // print('Order marked as Done successfully.');

        fetchOrders().then((value) {
          setState(() {
            isLoading = false;
            orders = value;
            filteredOrders = value;
            ElegantNotification.success(
                    title: Text("Done"),
                    description: Text("The Order has been marked as Done"))
                .show(context);
          });
        });
        // Handle success scenario
      } else {
        // Handle error scenario
      }
    } catch (error) {
      // Handle error scenario
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void searchOrder(String searchQuery) {
    setState(() {
      // print("searching. " + searchQuery);
      if (searchQuery.isEmpty) {
        // If search query is empty, display all orders
        filteredOrders = List.from(orders);
        // orders = orders;
      } else {
        filteredOrders = orders
            .where((order) =>
                order.orderId
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                order.customerPhone.contains(searchQuery) ||
                order.customerName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                order.orderStatus
                    .toUpperCase()
                    .contains(searchQuery.toUpperCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          'Orders',
        ),
        titleTextStyle: TextStyle(
          color: Colors.white
        ),
        centerTitle: true,
        backgroundColor: GlobalVariables.primaryColor,
        // leading: Text(userDetails[0]!.username) ,
        leading: userDetails.isNotEmpty ? Text(userDetails[0].username) : SizedBox(),

      ),
      body: Container(
        color: Colors.grey[250],
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                searchOrder(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Order, Name, Phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredOrders.length <= 0
                    ? Center(child: Text("No Order Found!!!"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => orderDetails(
                                //       orderId: order.id,
                                //     ),
                                //   ),
                                // );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => orderDetailsNew(
                                      orderId: order.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 5, right: 5, top: 0),
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
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: GlobalVariables.primaryColor,
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          // color: GlobalVariables.primaryColor,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Text(
                                                order.orderId,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                        title: (order.customerName == null ||
                                                order.customerName == '')
                                            ? Text(
                                                "No Customer Name",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              )
                                            : (order.customerPhone == null ||
                                                    order.customerPhone == '' ||
                                                    order.customerPhone == ' ')
                                                ? Text(
                                                    order.customerName,
                                                    // order.clothName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                : Text(
                                                    order.customerName +
                                                        " [" +
                                                        order.customerPhone +
                                                        "]",
                                                    // order.clothName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                        subtitle: order.orderStatus
                                                    .toUpperCase() ==
                                                "PENDING"
                                            ? Text(
                                                "[" +
                                                    order.orderStatus
                                                        .toUpperCase() +
                                                    "]",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              )
                                            : Text(
                                                "[" +
                                                    order.orderStatus
                                                        .toUpperCase() +
                                                    "]",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
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
                                              child: Text('Mark As Done'),
                                              value: 'done',
                                            ),
                                            PopupMenuItem(
                                              child: Text('Mark As Delivered'),
                                              value: 'delivered',
                                            ),
                                            PopupMenuItem(
                                              child: Text('Delete'),
                                              value: 'delete',
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              // Implement edit functionality
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      editOrder(
                                                    orderId: order.id,
                                                  ),
                                                ),
                                              );
                                            } else if (value == 'done') {
                                              // Implement Done functionality
                                              markAsDone(order.id);
                                            } else if (value == 'delivered') {
                                              markAsDelivered(order.id);
                                              // Implement delivered functionality
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Confirm Deletion'),
                                                    content: Text(
                                                        'Are you sure you want to delete this order?'),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                      ),
                                                      TextButton(
                                                        child: Text('Delete'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          deleteOrder(order.id);
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
            builder: (context) => addOrder(),
            //  addOrder(),
          ));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
