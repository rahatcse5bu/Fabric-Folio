import 'dart:convert';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/colors.dart';

import 'OrderDetailsOld.dart';
import 'addOrderOld.dart';
import 'editOrderOld.dart';

class OrdersOld extends StatefulWidget {
  const OrdersOld({super.key});

  @override
  State<OrdersOld> createState() => _OrdersOldState();
}

class Order {
  final String id;
  final String orderId;
  final String orderNote;
  final String clothName;
  final String orderStatus;
  final Customer customer;

  Order({
    required this.id,
    required this.orderId,
    required this.orderNote,
    required this.clothName,
    required this.customer,
    required this.orderStatus,
  });
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

class _OrdersOldState extends State<OrdersOld> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  List<Map<String, dynamic>> customers = [];
  TextEditingController _searchController = TextEditingController();

//my variables starts

  String selectedCustomerId = '64ae9f6d559978be96f6c33b';
  String _selectedCustomer = 'Sujan';

  //my variables ends
  Future<List<Order>> fetchOrders() async {
    final response = await http.get(
        Uri.parse('https://nuriya-tailers-backend.vercel.app/api/orders/'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Order> orderList = [];
      for (var order in jsonData['data']) {
        orderList.add(Order(
          id: order['_id'],
          orderId: order['orderId'],
          orderNote: order['orderNote'],
          clothName: order['clothName'],
          orderStatus: order['orderStatus'],
          customer: Customer(
            id: order['customerId']['_id'],
            customerName: order['customerId']['customerName'],
            customerPhone: order['customerId']['customerPhone'],
            customerLocation: order['customerId']['customerLocation'],
          ),
        ));
      }
      return orderList;
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders().then((value) {
      setState(() {
        orders = value;
        filteredOrders = value;
      });
    });
    // fetchCustomers().then((value) {
    //   setState(() {
    //     customers = value;
    //     if (customers.isNotEmpty) {
    //       _selectedCustomer = customers[0]['customerName'];
    //       selectedCustomerId = customers[0]['_id'];
    //     }
    //   });
    // });
  }

  Future<void> deleteOrder(String id) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/$id';
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

//              'customerId'	{
//               "_id":	"64ae9f6d559978be96f6c33b",
// "customerName":	"ests ts",
// "customerPhone"	:"212431234123sf3424",
// "customerLocation":	"barishal",
// "createdAt":	"2023-07-12T12:41:17.756Z",
// "updatedAt":	"2023-07-12T12:41:17.756Z"
//               },
        // {
        // "orderNote": "Sample order 1",
        // "customerId": "64ae9f6d559978be96f6c33b",
        // "totalPrice": 100,
        // "estimatedDeliveryTime": "2023-07-15T10:00:00.000Z",
        // "deliveredOn": null,
        // "orderStatus": "pending",
        // "clothName": "Anis Molla",
        // "clothType": "Cotton",
        // "lomba": "Sample lomba",
        // "payerMuhri": "Sample payer muhri",
        // "hatarMuhri": "Sample hatar muhri",
        // "hiegh": "Sample hiegh",
        // "puut": "Sample puut",
        // "body": "Sample body",
        // "hata": "Sample hata",
        // "kolarToyri": "Sample kolar toyri",
        // "komor": "Sample komor",
        // "isPoket": true,
        // "isChain": false,
        // "isMotaShuta": true,
        // "isDoubleSelai": false,
        // "isMotaRabar": true,
        // "is2Pocket": false,
        // "isMobilePocket": true,
        // "isBendRoundColar": false,
        // "isKotiColar": true,
        // "isDoublePlate": false,
        // "isRoundcolar": true,
        // "isSinglePlate": false,
        // "isFull": true,
        // "isSamna": false,
        // "isColar": true,
        // "isMura": false,
        // "isHata": true,
        // "isKop": false,
        // "isSidePocket": true,
        // "isKandi": false,
        // "isFullBodySita": true,
        // "isColarSingle": false,
        // "isColarDouble": true,
        // "isSamnaSita": false,
        // "isGolGola": true,
        // "isOneChain": false,
        // "isOneGuntiDana": true,
        // "is3GuntiDana": false,
        // "price": 50
        // }
      }),
      headers: {'Content-Type': 'application/json'},
    );
    var myjson = jsonEncode({
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
      'orderStatus': 'pending',
    });
    print('customerId: $customerId');
    print('orderNote: $orderNote');
    print('clothName: $clothName');
    print('clothType: $clothType');
    print('price: $price');
    print('totalPrice: $price');
    print('estimatedDeliveryTime: ${estimatedDeliveryTime.toIso8601String()}');
    print('lomba: $lomba');
    print('payerMuhri: $payerMuhri');
    print('hatarMuhri: $hatarMuhri');
    print('hiegh: $hiegh');
    print('puut: $puut');
    print('body: $bodyy');
    print('hata: $hata');
    print('kolarToyri: $kolarToyri');
    print('komor: $komor');
    print('isPoket: $isPoket');
    print('isChain: $isChain');
    print('isMotaShuta: $isMotaShuta');
    print('isDoubleSelai: $isDoubleSelai');
    print('isMotaRabar: $isMotaRabar');
    print('is2Pocket: $is2Pocket');
    print('isMobilePocket: $isMobilePocket');
    print('isBendRoundColar: $isBendRoundColar');
    print('isKotiColar: $isKotiColar');
    print('isDoublePlate: $isDoublePlate');
    print('isRoundcolar: $isRoundcolar');
    print('isSinglePlate: $isSinglePlate');
    print('isFull: $isFull');
    print('isSamna: $isSamna');
    print('isColar: $isColar');
    print('isMura: $isMura');
    print('isHata: $isHata');
    print('isKop: $isKop');
    print('isSidePocket: $isSidePocket');
    print('isKandi: $isKandi');
    print('isFullBodySita: $isFullBodySita');
    print('isColarSingle: $isColarSingle');
    print('isColarDouble: $isColarDouble');
    print('isSamnaSita: $isSamnaSita');
    print('isGolGola: $isGolGola');
    print('isOneChain: $isOneChain');
    print('isOneGuntiDana: $isOneGuntiDana');
    print('is3GuntiDana: $is3GuntiDana');
    print(myjson.toString());

    if (response.statusCode == 200) {
      // id = jsonDecode(response.body)['_id'];
      orderId = jsonDecode(response.body)['orderId'];
      print("Order Id: $orderId");
      setState(() {});
    } else {
      print("Error: " + response.statusCode.toString());
    }
  }

  Future<void> markAsDelivered(String orderId) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/$orderId';
    final body = jsonEncode({'orderStatus': 'delivered'});

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        print('Order marked as delivered successfully.');
        // Handle success scenario
      } else {
        // Handle error scenario
      }
    } catch (error) {
      // Handle error scenario
    }
  }

  Future<void> markAsDone(String orderId) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/$orderId';
    final body = jsonEncode({'orderStatus': 'done'});

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        print('Order marked as Done successfully.');
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
                order.customer.customerPhone.contains(searchQuery) ||
                order.customer.customerName
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
        title: Text(
          'Orders',
        ),
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
                searchOrder(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Order, Phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 10),
            filteredOrders.length <= 0
                ? Center(child: Text("No Order Found!!!"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => orderDetails(
                                  orderId: order.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 0),
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
                                        borderRadius: BorderRadius.circular(8),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    title: Text(
                                      order.customer.customerName +
                                          " [" +
                                          order.customer.customerPhone +
                                          "]",
                                      // order.clothName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      order.clothName +
                                          " [" +
                                          order.orderStatus.toUpperCase() +
                                          "]",
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
                                                  editOrderOld(
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
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Deletion'),
                                                content: Text(
                                                    'Are you sure you want to delete this order?'),
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
            builder: (context) => addOrderOld(),
          ));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
