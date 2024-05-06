import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'editOrderOld.dart';
import 'OrdersOld.dart';
import 'editOrder.dart';

class orderDetails extends StatefulWidget {
  const orderDetails({super.key, required this.orderId});
  final String orderId;

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  Map<String, dynamic> orderDetails = {};
  bool isLoading = true;
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/$orderId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final orderDetails = jsonData['data'];
        return orderDetails;
      } else {
        throw Exception('Failed to retrieve order details');
      }
    } catch (error) {
      print('Error occurred while retrieving order details: $error');
      throw Exception('Failed to retrieve order details');
    }
  }

  String formatDate(String dateTimeString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final outputFormat = DateFormat.yMMMMd().add_jms();

    final dateTime = inputFormat.parse(dateTimeString);
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }

  Future<void> deleteOrder(String id) async {
    final url = 'https://nuriya-tailers-backend.vercel.app/api/orders/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      // Material PageRoute is used to slide the page to the right.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OrdersOld(),
        ),
      );
      setState(() {
        // orders.removeWhere((order) => order.id == id);
      });
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
        setState(() {
          orderDetails['orderStatus'] = 'delivered';
          // fetchOrders().then((value) {
          //   setState(() {
          //     orders = value;
          //   });
          // });
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

  @override
  void initState() {
    super.initState();
    getOrderDetails(widget.orderId).then((value) {
      setState(() {
        orderDetails = value;
        isLoading = false;

        print(orderDetails.toString());
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersOld()),
              );
            });
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
                        'পোশাকের নাম', orderDetails['clothName'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'পোশাক টাইপ', orderDetails['clothType'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'অর্ডার নোট', orderDetails['orderNote'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'দাম', orderDetails['price'].toString() ?? '0.0'),
                    buildOrderDetailRow('পেইড',
                        orderDetails['paidAmount'].toString() ?? '0.00'),
                    buildOrderDetailRow('অর্ডার স্ট্যাটাস',
                        orderDetails['orderStatus'] ?? 'N/A'),
                    // buildOrderDetailRow(
                    //     'Order Amount', '₹ ${orderDetails['paidAmount'] ?? 'N/A'}'),
                    // buildOrderDetailRow(
                    //     'Order Type', orderDetails['paymentType'] ?? 'N/A'),
                    buildOrderDetailRow('কাস্টমারের নাম',
                        orderDetails['customerId']['customerName'] ?? 'N/A'),
                    buildOrderDetailRow('কাস্টমারের ফোন নাম্বার',
                        orderDetails['customerId']['customerPhone'] ?? 'N/A'),
                    buildOrderDetailRow(
                        'কাস্টমারের ঠিকানা',
                        orderDetails['customerId']['customerLocation'] ??
                            'N/A'),
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
                                  fontSize: 15,
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
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
                            child: Text('Edit Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              deleteOrder(orderDetails['_id']);
                            },
                            child: Text('অর্ডার মুছেন'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                          border: TableBorder.all(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              width: 1.0,
                              color: Colors.grey[350]!),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("লম্বা"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['lomba'].toString() ?? 'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("পায়ের মুহরি"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['payerMuhri'].toString() ??
                                        'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('হাতার মুহরি'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['hatarMuhri'].toString() ??
                                        'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("হাই"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['hiegh'].toString() ?? 'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("পুট"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['puut'].toString() ?? 'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("বডি"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['body'].toString() ?? 'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("হাতা"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['hata'].toString() ?? 'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("কলার তৈরি"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['kolarToyri'].toString() ??
                                        'N/A'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("কোমর"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    orderDetails['komor'].toString() ?? 'N/A'),
                              ),
                            ]),
                          ]),
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
                      child: Table(
                        border: TableBorder.all(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            width: 1.0,
                            color: Colors.grey[350]!),
                        children: [
                          tableRow('পকেট', orderDetails['isPoket'], 'চেইন',
                              orderDetails['isChain']),
                          tableRow(
                              'মোটাসুতা',
                              orderDetails['isMotaShuta'],
                              'ডাবল সেলাই',
                              orderDetails['isDoubleSelai'] == Null
                                  ? false
                                  : orderDetails['isDoubleSelai']),
                          tableRow(
                              'মোটা রাবার',
                              orderDetails['isMotaRabar'],
                              '২ পকেট',
                              orderDetails['is2Pocket'] == Null
                                  ? false
                                  : orderDetails['is2Pocket']),
                          tableRow(
                              'মোবাইল পকেট',
                              orderDetails['isMobilePocket'],
                              'বেন্ড রাউন্ড কলার',
                              orderDetails['isBendRoundColar'] == Null
                                  ? false
                                  : orderDetails['isBendRoundColar']),
                          tableRow(
                              'কটি কলার',
                              orderDetails['isKotiColar'],
                              'ডাবল প্লেট',
                              orderDetails['isDoublePlate'] == Null
                                  ? false
                                  : orderDetails['isDoublePlate']),
                          tableRow(
                              'রাউন্ড কলার',
                              orderDetails['isRoundcolar'],
                              'সিঙ্গেল প্লেট',
                              orderDetails['isSinglePlate'] == Null
                                  ? false
                                  : orderDetails['isSinglePlate']),
                          tableRow(
                              'ফুল',
                              orderDetails['isFull'],
                              'সামনা',
                              orderDetails['isSamna'] == Null
                                  ? false
                                  : orderDetails['isSamna']),
                          tableRow(
                              'কলার',
                              orderDetails['isColar'],
                              'মুরা',
                              orderDetails['isMura'] == Null
                                  ? false
                                  : orderDetails['isMura']),
                          tableRow(
                              'হাতা',
                              orderDetails['isHata'],
                              'কপ',
                              orderDetails['isKop'] == Null
                                  ? false
                                  : orderDetails['isKop']),
                          tableRow(
                              'সাইড পকেট',
                              orderDetails['isSidePocket'],
                              'কান্দি',
                              orderDetails['isKandi'] == Null
                                  ? false
                                  : orderDetails['isKandi']),
                          tableRow(
                              'ফুল বডি সিটা',
                              orderDetails['isFullBodySita'],
                              'কলার সিঙ্গেল',
                              orderDetails['isColarSingle'] == Null
                                  ? false
                                  : orderDetails['isColarSingle']),
                          tableRow(
                              'কলার ডবল',
                              orderDetails['isColarDouble'],
                              'সামনা সিটা',
                              orderDetails['isSamnaSita'] == Null
                                  ? false
                                  : orderDetails['isSamnaSita']),
                          tableRow(
                              'গোলগলা',
                              orderDetails['isGolGola'],
                              '১ চেইন',
                              orderDetails['isOneChain'] == Null
                                  ? false
                                  : orderDetails['isOneChain']),
                          tableRow(
                              '১ গুন্টিদানা',
                              orderDetails['isOneGuntiDana'],
                              '৩ গুন্টি দানা',
                              orderDetails['is3GuntiDana'] == Null
                                  ? false
                                  : orderDetails['is3GuntiDana']),
                        ],
                      ),
                    )
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
              value2
                  ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                  : Icon(Icons.close_sharp, color: Colors.red, size: 20),
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
