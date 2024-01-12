import 'dart:async';
import 'dart:convert';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import '../Navbar/navbar.dart';
import 'Orders.dart';
import 'editOrder.dart';
import 'editOrderOld.dart';
import 'OrdersOld.dart';

class orderDetailsNew extends StatefulWidget {
  const orderDetailsNew({super.key, required this.orderId});
  final String orderId;

  @override
  State<orderDetailsNew> createState() => _orderDetailsNewState();
}

class _orderDetailsNewState extends State<orderDetailsNew> {
  Map<String, dynamic> orderDetails = {};
  List<Map<String, dynamic>> clothList = [];
  double totalPrice = 0;
  bool isLoading = true;

  String formatDate(String dateTimeString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final outputFormat = DateFormat.yMMMMd().add_jms();

    final dateTime = inputFormat.parse(dateTimeString);
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }

  Future<void> deleteOrder(String id) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      // Material PageRoute is used to slide the page to the right.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Orders(),
        ),
      );
      setState(() {
        // orders.removeWhere((order) => order.id == id);
      });
    }
  }

  Future<void> markAsDelivered(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';
    final body = jsonEncode({'orderStatus': 'delivered'});

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        print('Order marked as delivered successfully.');
        setState(() {
          orderDetails['orderStatus'] = 'delivered';
          ElegantNotification.success(
                  title: Text("Delivered"),
                  description: Text("The Order has been marked as Delivered"))
              .show(context);
        });
        // Handle success scenario
      } else {
        print(
            'Failed to mark order as delivered. Status Code: ${response.statusCode}');
        // Handle error scenario
      }
    } catch (error) {
      print('Error occurred while marking order as delivered: $error');
      // Handle error scenario
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> clothList) {
    double totalPrice = 0.0;

    for (var clothItem in clothList) {
      dynamic unitPrice = clothItem['price'];
      int clothQuantity = clothItem['clothQuantity'];

      if (unitPrice is int) {
        unitPrice = unitPrice.toDouble();
      } else if (unitPrice is! double) {
        throw Exception('Invalid price type: ${unitPrice.runtimeType}');
      }

      double clothTotalPrice = unitPrice * clothQuantity;
      totalPrice += clothTotalPrice;
    }

    return totalPrice;
  }

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final orderDetails = jsonData['data'];
        // print('Order Details : ${orderDetails}');

        return orderDetails;
      } else {
        throw Exception('Failed to retrieve order details');
      }
    } catch (error) {
      print('Error occurred while retrieving order details: $error');
      throw Exception('Failed to retrieve order details');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderDetails1(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final orderDetails = jsonData['data'];
        // print('Order Details : ${orderDetails}');
        final List<dynamic> clothListData = await orderDetails['clothList'];
        late List<Map<String, dynamic>> clothList = [];

        for (var clothData in clothListData) {
          if (clothData is Map<String, dynamic>) {
            clothList.add(Map<String, dynamic>.from(clothData));
          }
        }

        return clothList;
      } else {
        throw Exception('Failed to retrieve order details');
      }
    } catch (error) {
      print('Error occurred while retrieving order details: $error');
      throw Exception('Failed to retrieve order details');
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderDetails(widget.orderId).then((value) {
      setState(() {
        orderDetails = value;

        isLoading = false;
        final List<dynamic> clothListData = orderDetails['clothList'];
        // final List<Map<String, dynamic>> clothList = [];

        for (var clothData in clothListData) {
          if (clothData is Map<String, dynamic>) {
            clothList.add(Map<String, dynamic>.from(clothData));
          }
        }
        totalPrice = calculateTotalPrice(clothList);
        // print(orderDetails.toString());
        // print("clothList: " + clothList.toString());
        // print("totalPrice: " + totalPrice.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: const Text(
          'Order Details',
        ),
                titleTextStyle: TextStyle(
          color: Colors.white
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Timer(
                const Duration(seconds: 1),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavbarScreen())));
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   Navigator.of(context).pop();
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => OrdersOld()),
            //   );
            // });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 20),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    buildOrderDetailRow(
                        'অর্ডার আইডি', orderDetails['orderId'] ?? 'N/A'),

                    buildOrderDetailRow('অর্ডার তারিখ',
                        formatDate(orderDetails['createdAt']) ?? 'N/A'),
                    buildOrderDetailRow(
                        'অর্ডার ডেলিভারি তারিখ',
                        formatDate(orderDetails['estimatedDeliveryTime']) ??
                            'N/A'),
                    // buildOrderDetailRow(
                    //     'পোশাকের নাম', orderDetails['clothName'] ?? 'N/A'),
                    // buildOrderDetailRow(
                    //     'পোশাক টাইপ', orderDetails['clothType'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'অর্ডার নোট', orderDetails['orderNote'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'টোটাল দাম', totalPrice.toString() ?? '0.0'),
                    buildOrderDetailRow(
                        'টাকা বাকী',
                        (totalPrice - orderDetails['paidAmount']).toString() ??
                            '0.0'),
                    buildOrderDetailRow('কাস্টমার পেইড',
                        orderDetails['paidAmount'].toString() ?? '0.00'),
                    buildOrderDetailRow('অর্ডার স্ট্যাটাস',
                        orderDetails['orderStatus'].toUpperCase() ?? 'N/A'),
                    // buildOrderDetailRow(
                    //     'Order Amount', '₹ ${orderDetails['paidAmount'] ?? 'N/A'}'),
                    // buildOrderDetailRow(
                    //     'Order Type', orderDetails['paymentType'] ?? 'N/A'),
                    buildOrderDetailRow('কাস্টমারের নাম',
                        orderDetails['customerName'] ?? 'N/A'),
                    buildOrderDetailRow('কাস্টমারের ফোন নাম্বার',
                        orderDetails['customerPhone'] ?? 'N/A'),
                    buildOrderDetailRow('কাস্টমারের ঠিকানা',
                        orderDetails['customerLocation'] ?? 'N/A'),
                    Divider(
                      color: Colors.grey[350]!,
                    ),

                    Row(
                      children: [
                        // two elevated button for mark as completed and mark as done
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              orderDetails['orderStatus'] == 'pending'
                                  ? markAsDelivered(orderDetails['_id'])
                                  : null;
                            },
                            child: Text('অর্ডার কমপ্লিট',
                                style: TextStyle(
                                  color:
                                      orderDetails['orderStatus'] == 'pending'
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // markAsDelivered(orderDetails['_id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => editOrder(
                                          orderId: orderDetails['_id'],
                                        )),
                              );
                            },
                            child: Text('Edit Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              deleteOrder(orderDetails['_id']);
                            },
                            child: Text('অর্ডার মুছুন',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Column(
                      children: [
                        for (var clothItem in clothList) ...[
                          ExpansionTileCard(
                            baseColor: Colors.grey[200],
                            expandedColor: Colors.grey[200],
                            title: Text(
                              "${clothItem['clothType']} x ${clothItem['clothQuantity']}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      border: TableBorder.all(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          width: 1.0,
                                          color: Colors.grey[350]!),
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Unit Price"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                clothItem['price'].toString() ??
                                                    '0.0'),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Quantity"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                clothItem['clothQuantity']
                                                        .toString() ??
                                                    'N/A'),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Total Price (${clothItem['clothType']})"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((clothItem['price'] *
                                                        clothItem[
                                                            'clothQuantity'])
                                                    .toString() ??
                                                '0.0'),
                                          ),
                                        ]),
                                        if (clothItem['clothType'] == "সেলোয়ার" ||
                                            clothItem['clothType'] ==
                                                "ধুতি সেলোয়ার" ||
                                            clothItem['clothType'] ==
                                                "পায়জামা" ||
                                            clothItem['clothType'] ==
                                                'চোষা পায়জামা') ...[
                                          //Start Seloyar Input Section

                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("লম্বা"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['lomba']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("পায়ের মুহরি"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['payerMuhri']
                                                          .toString() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("হাই"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['hiegh']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("কোমর"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['komor']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("রানের লুজ"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['ranerLuj']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),

                                          // End Of Seloyar Input Section
                                        ] else ...[
                                          /// Start Panjabi Input Section
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("লম্বা"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['lomba']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("ঘের"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['gher']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("লুজ"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['luj'].toString() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("বুক পকেট"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['bookPocket']
                                                          .toString() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('হাতার মুহরি'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['hatarMuhri']
                                                          .toString() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("পুট"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['puut']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("বডি"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['body']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("হাতা"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['hata']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("কলার তৈরি"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['kolarToyri']
                                                          .toString() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("চুড়ি হাতা"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(clothItem['churiHata']
                                                      .toString() ??
                                                  'N/A'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("কপ"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  clothItem['kop'].toString() ??
                                                      'N/A'),
                                            ),
                                          ]),

                                          //End Panjabi Input Section
                                        ],
                                      ]),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[350]!,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    border: TableBorder.all(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        width: 1.0,
                                        color: Colors.grey[350]!),
                                    children: [
                                      if (clothItem['clothType'] == "সেলোয়ার" ||
                                          clothItem['clothType'] ==
                                              "ধুতি সেলোয়ার" ||
                                          clothItem['clothType'] == "পায়জামা" ||
                                          clothItem['clothType'] ==
                                              'চোষা পায়জামা') ...[
                                        //Strat Seloyar Section Switchtile
                                        tableRow('পকেট', clothItem['isPoket'],
                                            'চেইন', clothItem['isChain']),
                                        tableRow(
                                            'মোটাসুতা',
                                            clothItem['isMotaShuta'],
                                            'ডাবল সেলাই',
                                            clothItem['isDoubleSelai'] == Null
                                                ? false
                                                : clothItem['isDoubleSelai']),
                                        tableRow(
                                            'মোটা রাবার',
                                            clothItem['isMotaRabar'],
                                            '২ পকেট',
                                            clothItem['is2Pocket'] == Null
                                                ? false
                                                : clothItem['is2Pocket']),
                                        tableRow(
                                            'মোবাইল পকেট',
                                            clothItem['isMobilePocket'],
                                            'বেন্ড রাউন্ড কলার',
                                            clothItem['isBendRoundColar'] ==
                                                    Null
                                                ? false
                                                : clothItem[
                                                    'isBendRoundColar']),
                                        tableRow(
                                            'পিছনে পকেট',
                                            clothItem['isPichonePocket'],
                                            '১ পকেট',
                                            clothItem['isOnePocket'] == Null
                                                ? false
                                                : clothItem['isOnePocket']),
                                      ]
                                      //End of Seloyar SwitchTile
                                      else ...[
                                        //Start of Panjabi SwitchTile

                                        tableRow(
                                            'কটি কলার',
                                            clothItem['isKotiColar'],
                                            'ডাবল প্লেট',
                                            clothItem['isDoublePlate'] == Null
                                                ? false
                                                : clothItem['isDoublePlate']),
                                        tableRow(
                                            'রাউন্ড কলার',
                                            clothItem['isRoundcolar'],
                                            'সিঙ্গেল প্লেট',
                                            clothItem['isSinglePlate'] == Null
                                                ? false
                                                : clothItem['isSinglePlate']),
                                        tableRow(
                                            'ফুল',
                                            clothItem['isFull'],
                                            'সামনা',
                                            clothItem['isSamna'] == Null
                                                ? false
                                                : clothItem['isSamna']),
                                        tableRow(
                                            'কলার',
                                            clothItem['isColar'],
                                            'মুরা',
                                            clothItem['isMura'] == Null
                                                ? false
                                                : clothItem['isMura']),
                                        tableRow(
                                            'হাতা',
                                            clothItem['isHata'],
                                            'কপ',
                                            clothItem['isKop'] == Null
                                                ? false
                                                : clothItem['isKop']),
                                        tableRow(
                                            'সাইড পকেট',
                                            clothItem['isSidePocket'],
                                            'কান্দি',
                                            clothItem['isKandi'] == Null
                                                ? false
                                                : clothItem['isKandi']),
                                        tableRow(
                                            'ফুল বডি সিটা',
                                            clothItem['isFullBodySita'],
                                            'কলার সিঙ্গেল',
                                            clothItem['isColarSingle'] == Null
                                                ? false
                                                : clothItem['isColarSingle']),
                                        tableRow(
                                            'কলার ডবল',
                                            clothItem['isColarDouble'],
                                            'সামনা সিটা',
                                            clothItem['isSamnaSita'] == Null
                                                ? false
                                                : clothItem['isSamnaSita']),
                                        tableRow(
                                            'গোলগলা',
                                            clothItem['isGolGola'],
                                            '১ চেইন',
                                            clothItem['isOneChain'] == Null
                                                ? false
                                                : clothItem['isOneChain']),
                                        tableRow(
                                            '১ গুন্টিদানা',
                                            clothItem['isOneGuntiDana'],
                                            '৩ গুন্টি দানা',
                                            clothItem['is3GuntiDana'] == Null
                                                ? false
                                                : clothItem['is3GuntiDana']),
                                        tableRow(
                                          'বেন্ড রাউন্ড কলার',
                                          clothItem['isBendRoundColar'] == Null
                                              ? false
                                              : clothItem['isBendRoundColar'],
                                          '২ পকেট চেইন',
                                          clothItem['isTwoPocketChain'] == Null
                                              ? false
                                              : clothItem['isTwoPocketChain'],
                                        ),

                                        //End of Panjabi SwitchTile
                                      ]
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  TableRow tableRow(String label1, bool value1, String label2, bool value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              value1
                  ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                  : Icon(Icons.close_sharp, color: Colors.red, size: 20),
              SizedBox(
                width: 5,
              ),
              Text(label1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              label2 != ''
                  ? value2
                      ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                      : Icon(Icons.close_sharp, color: Colors.red, size: 20)
                  : Container(),
              SizedBox(
                width: 5,
              ),
              Text(label2),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOrderDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              value.toString(),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
