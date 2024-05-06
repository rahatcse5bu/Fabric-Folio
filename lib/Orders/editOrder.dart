import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/colors.dart';

import '../Navbar/navbar.dart';
import 'Orders.dart';
import 'OrdersOld.dart';

class editOrder extends StatefulWidget {
  const editOrder({super.key, required this.orderId});
  final String orderId;

  @override
  State<editOrder> createState() => _editOrderState();
}

class _editOrderState extends State<editOrder> {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> clothList = [];
  bool useCharacterKeyboardCustPhone = false;
  bool useCharacterKeyboardLomba = false;
  bool useCharacterKeyboardHeigh = false;
  bool useCharacterKeyboardKomor = false;
  bool useCharacterKeyboardPayerMuhri = false;
  bool useCharacterKeyboardHatarMuhri = false;
  bool useCharacterKeyboardBody = false;
  bool useCharacterKeyboardHata = false;
  bool useCharacterKeyboardKolar = false;
  bool useCharacterKeyboardRanerLuj = false;
  bool useCharacterKeyboardKop = false;
  bool useCharacterKeyboardChuriHata = false;
  bool useCharacterKeyboardGher = false;
  bool useCharacterKeyboardLuj = false;
  bool useCharacterKeyboardPuut = false;
  bool useCharacterKeyboardBookPocket = false;
// Function to add a new cloth item
  void _addClothItem() {
    setState(() {
      // Implement logic to add a new cloth item
      clothList.add({
        'clothName': '',
        'clothType': '',
        'clothQuantity': 0,
        'lomba': '',
        'payerMuhri': '',
        'hatarMuhri': '',
        'hiegh': '',
        'puut': '',
        'body': '',
        'hata': '',
        'kolarToyri': '',
        'komor': '',
        'ranerLuj': '',
        'kop': '',
        'gher': '',
        'luj': '',
        'bookPocket': '',
        'churiHata': '',
        'isPoket': false,
        'isTwoPocketChain': false,
        'isChain': false,
        'isMotaShuta': false,
        'isDoubleSelai': false,
        'isMotaRabar': false,
        'is2Pocket': false,
        'isOnePocket': false,
        'isMobilePocket': false,
        'isPichonePocket': false,
        'isBendRoundColar': false,
        'isKotiColar': false,
        'isDoublePlate': false,
        'isRoundcolar': false,
        'isSinglePlate': false,
        'isFull': false,
        'isSamna': false,
        'isColar': false,
        'isMura': false,
        'isHata': false,
        'isKop': false,
        'isSidePocket': false,
        'isKandi': false,
        'isFullBodySita': false,
        'isColarSingle': false,
        'isColarDouble': false,
        'isSamnaSita': false,
        'isGolGola': false,
        'isOneChain': false,
        'isOneGuntiDana': false,
        'is3GuntiDana': false,
        'price': 0,
      });
    });
  }

  //  'estimatedDeliveryTime': '',
  //     'deliveredOn': null,
  // Function to remove a cloth item at a given index
  void _removeClothItem(int index) {
    setState(() {
      // Implement logic to remove the cloth item at the given index
      clothList.removeAt(index);
    });
  }

  // Function to handle ClothList data changes when a field is updated
  void _updateClothItem(int index, String key, dynamic value) {
    setState(() {
      // Implement logic to update the cloth item at the given index
      clothList[index][key] = value;
    });
  }

  Map<String, dynamic> orderDetails = {};
  bool isLoading = true;
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';

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

        // print(orderDetails.toString());
        // print("clothList: " + clothList.toString());
      });
    });

    // fetchCustomers().then((value) {
    //   setState(() {
    //     customers = value;
    //     if (customers.isNotEmpty) {
    //       _selectedCustomer = customers[0]['customerName'];
    //       _selectedCustomerId = customers[0]['_id'];
    //     }
    //   });
    // });
  }

// String selectedCustomerId = '';
//my variables starts
  final _formKey = GlobalKey<FormState>();
  String _selectedCustomerName = 'Rahat';
  String _selectedCustomerPhone = '01793278360';
  String _selectedCustomerLocation = 'Barisal';
  String _orderNote = 'Nothing';

  double _paidAmount = 0.0;

  DateTime _estimatedDeliveryTime = DateTime.now();

  //my variables ends
  var orderId = 'errr';

  Future<String> updateOrder(
    String customerName,
    String customerPhone,
    String customerLocation,
    String orderNote,
    double paidAmount,
    DateTime estimatedDeliveryTime,
  ) async {
    orderId = widget.orderId;
    final url = 'https://fabric-folio.vercel.app/api/orders/$orderId';
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode({
        'customerName': orderDetails['customerName'],
        'customerPhone': orderDetails['customerPhone'],
        'customerLocation': orderDetails['customerLocation'],
        'orderNote': orderDetails['orderNote'],
        'paidAmount': orderDetails['paidAmount'],
        'estimatedDeliveryTime': orderDetails['estimatedDeliveryTime'],
        'clothList': clothList,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    var myJSON = jsonEncode({
      // 'customerId': orderDetails['customerId']['_id'],
      'orderNote': orderDetails['orderNote'],
      'paidAmount': orderDetails['paidAmount'],
      'estimatedDeliveryTime': orderDetails['estimatedDeliveryTime'],
      'clothList': clothList,
    });
    print(myJSON);

    if (response.statusCode == 200) {
      // id = jsonDecode(response.body)['_id'];
      print(jsonDecode(response.body));
      orderId = jsonDecode(response.body)['data']['orderId'];
      // print("Order Id: $orderId");

      return orderId;
    } else {
      print("Error: " + response.statusCode.toString());
      return 'error';
    }
  }

  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final response = await http.get(
        Uri.parse('https://nuriya-tailers-backend.vercel.app/api/customers'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        leading: IconButton(
            onPressed: () {
              Timer(
                  const Duration(seconds: 1),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavbarScreen())));
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text('Edit Order'),
                titleTextStyle: TextStyle(
          color: Colors.white
        ),
        centerTitle: true,
      ),
      body: orderDetails.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: SingleChildScrollView(
                child: // Extra Code Here
// ClothList UI
                    Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: orderDetails['customerName'],
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
                          _selectedCustomerName = value;
                          orderDetails['customerName'] = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: orderDetails['customerPhone'],
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
                          _selectedCustomerPhone = value;
                          orderDetails['customerPhone'] = value;
                        });
                      },
                      inputFormatters: [
                        // Use numeric input formatter initially
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: useCharacterKeyboardCustPhone
                          ? TextInputType.text // Character keyboard
                          : TextInputType.number, // Numeric keyboard
                      onTap: () {
                        setState(() {
                          useCharacterKeyboardCustPhone =
                              !useCharacterKeyboardCustPhone;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextFormField(
                      maxLines: 5,
                      initialValue: orderDetails['customerLocation'],
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
                          _selectedCustomerLocation = value;
                          orderDetails['customerLocation'] = value;
                        });
                      },
                    ),
                    // Text(
                    //   "Customer Name: " +
                    //       orderDetails['customerId']['customerName'],
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold),
                    // ),

                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
                      initialValue: orderDetails['orderNote'],
                      decoration: InputDecoration(
                          labelText: 'অর্ডার নোট',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an order note';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          orderDetails['orderNote'] = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              // Use numeric input formatter initially
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            initialValue: orderDetails['paidAmount'].toString(),
                            decoration: InputDecoration(
                                labelText: 'পেইড',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an amount';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                orderDetails['paidAmount'] =
                                    double.parse(value);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            title: Text('আনুমানিক ডেলিভারি'),
                            subtitle: Text(
                                '${_estimatedDeliveryTime.toLocal()}',
                                style: TextStyle(fontSize: 8)),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    orderDetails['estimatedDeliveryTime'],
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              );
                              if (picked != null &&
                                  picked != _estimatedDeliveryTime) {
                                setState(() {
                                  orderDetails['estimatedDeliveryTime'] =
                                      picked;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: clothList.length,
                      itemBuilder: (context, index) {
                        final clothItem = clothList[index];

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  // color: GlobalVariables.primaryColor,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 95.4,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    color: GlobalVariables.primaryColor,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Cloth ${index + 1}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              // Display cloth details

                              TextFormField(
                                initialValue: clothItem['clothName'],
                                maxLines: 2,
                                decoration: InputDecoration(
                                    labelText: 'কাপড়ের নাম',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a cloth name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _updateClothItem(index, 'clothName', value);
                                  // setState(() {
                                  //   _clothName = value;
                                  // });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                value: clothItem['clothType'],
                                onChanged: (value) {
                                  _updateClothItem(index, 'clothType', value);
                                  // setState(() {
                                  //   _clothType = value.toString();
                                  // });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'সেলোয়ার',
                                    child: Text('সেলোয়ার'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'পায়জামা',
                                    child: Text('পায়জামা'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'পাঞ্জাবি',
                                    child: Text('পাঞ্জাবি'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'কলি পাঞ্জাবি',
                                    child: Text('কলি পাঞ্জাবি'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'গোল জামা',
                                    child: Text('গোল জামা'),
                                  ),
                                  DropdownMenuItem(
                                    value: '১ ছাটা পাঞ্জাবী',
                                    child: Text('১ ছাটা পাঞ্জাবী'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'রাউন্ড কাবলী',
                                    child: Text('রাউন্ড কাবলী'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'শর্ট পাঞ্জাবী',
                                    child: Text('শর্ট পাঞ্জাবী'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'অ্যারাবিয়ান জুব্বা',
                                    child: Text('অ্যারাবিয়ান জুব্বা'),
                                  ),
                                  DropdownMenuItem(
                                    value: '১ ছাটা জুব্বা',
                                    child: Text('১ ছাটা জুব্বা'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'গোল পাঞ্জাবী',
                                    child: Text('গোল পাঞ্জাবী'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ফতুয়া',
                                    child: Text('ফতুয়া'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'কাপড় টাইপ নির্বাচন করুন',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              // TextFormField(
                              //   initialValue: clothItem['payerMuhri'],
                              //   onChanged: (value) =>
                              //       _updateClothItem(index, 'payerMuhri', value),
                              //   decoration: InputDecoration(labelText: 'Payer Muhri'),
                              // ),
                              // SwitchListTile(
                              //   value: clothItem['isMotaRabar'],
                              //   onChanged: (value) =>
                              //       _updateClothItem(index, 'isMotaRabar', value),
                              //   title: Text('Is Mota Rabar?'),
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      inputFormatters: [
                                        // Use numeric input formatter initially
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                      initialValue:
                                          clothItem['price'].toString(),
                                      decoration: InputDecoration(
                                          labelText: 'Price',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      onChanged: (value) {
                                        _updateClothItem(index, 'price', value);
                                        // setState(() {
                                        //   _lomba = value;
                                        // });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      inputFormatters: [
                                        // Use numeric input formatter initially
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType
                                          .number, // Numeric keyboard
                                      initialValue:
                                          clothItem['clothQuantity'].toString(),
                                      decoration: InputDecoration(
                                          labelText: 'Quantity',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      onChanged: (value) {
                                        _updateClothItem(
                                            index, 'clothQuantity', value);
                                        // setState(() {
                                        //   _payerMuhri = value;
                                        // });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //Start Seloyar/Payjama Section SwitchTile
                              if (clothItem['clothType'] == "সেলোয়ার" ||
                                  clothItem['clothType'] == "ধুতি সেলোয়ার" ||
                                  clothItem['clothType'] == "পায়জামা" ||
                                  clothItem['clothType'] == 'চোষা পায়জামা') ...[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['lomba'],
                                            decoration: InputDecoration(
                                                labelText: 'লম্বা',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'lomba', value);
                                              // setState(() {
                                              //   _lomba = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardLomba
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardLomba =
                                                    !useCharacterKeyboardLomba;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['hiegh'],
                                            decoration: InputDecoration(
                                                labelText: 'হাই',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'hiegh', value);
                                              // setState(() {
                                              //   _hiegh = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardHeigh
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardHeigh =
                                                    !useCharacterKeyboardHeigh;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: clothItem['komor'],
                                          decoration: InputDecoration(
                                              labelText: 'কোমর',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              )),
                                          onChanged: (value) {
                                            _updateClothItem(
                                                index, 'komor', value);
                                            // setState(() {
                                            //   _komor = value;
                                            // });
                                          },
                                          inputFormatters: [
                                            // Use numeric input formatter initially
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          keyboardType:
                                              useCharacterKeyboardKomor
                                                  ? TextInputType
                                                      .text // Character keyboard
                                                  : TextInputType
                                                      .number, // Numeric keyboard
                                          onTap: () {
                                            setState(() {
                                              useCharacterKeyboardKomor =
                                                  !useCharacterKeyboardKomor;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: clothItem['payerMuhri'],
                                          decoration: InputDecoration(
                                              labelText: 'পায়ের মুহরি',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              )),
                                          onChanged: (value) {
                                            _updateClothItem(
                                                index, 'payerMuhri', value);
                                            // setState(() {
                                            //   _payerMuhri = value;
                                            // });
                                          },
                                          inputFormatters: [
                                            // Use numeric input formatter initially
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          keyboardType:
                                              useCharacterKeyboardPayerMuhri
                                                  ? TextInputType
                                                      .text // Character keyboard
                                                  : TextInputType
                                                      .number, // Numeric keyboard
                                          onTap: () {
                                            setState(() {
                                              useCharacterKeyboardPayerMuhri =
                                                  !useCharacterKeyboardPayerMuhri;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['ranerLuj'],
                                            decoration: InputDecoration(
                                                labelText: 'রানের লুজ',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'ranerLuj', value);
                                              // setState(() {
                                              //   _payerMuhri = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardRanerLuj
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardRanerLuj =
                                                    !useCharacterKeyboardRanerLuj;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ] else ...[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['lomba'],
                                            decoration: InputDecoration(
                                                labelText: 'লম্বা',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'lomba', value);
                                              // setState(() {
                                              //   _lomba = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardLomba
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardLomba =
                                                    !useCharacterKeyboardLomba;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['body'],
                                            decoration: InputDecoration(
                                                labelText: 'বডি',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'body', value);
                                              // setState(() {
                                              //   _bodyi = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardBody
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardBody =
                                                    !useCharacterKeyboardBody;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['gher'],
                                            decoration: InputDecoration(
                                                labelText: 'ঘের',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'gher', value);
                                              // setState(() {
                                              //   _lomba = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardGher
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardGher =
                                                    !useCharacterKeyboardGher;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['luj'],
                                            decoration: InputDecoration(
                                                labelText: 'লুজ',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'luj', value);
                                              // setState(() {
                                              //   _bodyi = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardLuj
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardLuj =
                                                    !useCharacterKeyboardLuj;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['puut'],
                                            decoration: InputDecoration(
                                                labelText: 'পুট/কান্দি',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'puut', value);
                                              // setState(() {
                                              //   _puuti = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardPuut
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardPuut =
                                                    !useCharacterKeyboardPuut;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue:
                                                clothItem['hatarMuhri'],
                                            decoration: InputDecoration(
                                                labelText: 'হাতার মুহরি',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'hatarMuhri', value);
                                              // setState(() {
                                              //   _hatarMuhri = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardHatarMuhri
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardHatarMuhri =
                                                    !useCharacterKeyboardHatarMuhri;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['hata'],
                                            decoration: InputDecoration(
                                                labelText: 'হাতা',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'hata', value);
                                              // setState(() {
                                              //   _haatai = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardHata
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardHata =
                                                    !useCharacterKeyboardHata;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue:
                                                clothItem['kolarToyri'],
                                            decoration: InputDecoration(
                                                labelText: 'কলার তৈরি',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'kolarToyri', value);
                                              // setState(() {
                                              //   _colarToyrii = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardKolar
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardKolar =
                                                    !useCharacterKeyboardKolar;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: clothItem['kop'],
                                            decoration: InputDecoration(
                                                labelText: 'কপ',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'kop', value);
                                              // setState(() {
                                              //   _haatai = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardKop
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardKop =
                                                    !useCharacterKeyboardKop;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue:
                                                clothItem['churiHata'],
                                            decoration: InputDecoration(
                                                labelText: 'চুড়ি হাতা',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'churiHata', value);
                                              // setState(() {
                                              //   _colarToyrii = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardChuriHata
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardChuriHata =
                                                    !useCharacterKeyboardChuriHata;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue:
                                                clothItem['bookPocket'],
                                            decoration: InputDecoration(
                                                labelText: 'বুক পকেট',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'bookPocket', value);
                                              // setState(() {
                                              //   _haatai = value;
                                              // });
                                            },

                                            keyboardType:
                                                useCharacterKeyboardBookPocket
                                                    ? TextInputType
                                                        .text // Character keyboard
                                                    : TextInputType
                                                        .number, // Numeric keyboard
                                            onTap: () {
                                              setState(() {
                                                useCharacterKeyboardBookPocket =
                                                    !useCharacterKeyboardBookPocket;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                              //End Panjabi Section Input
//End Seloyar/Payjama Section Input

                              SizedBox(
                                height: 10,
                              ),

                              //Start Seloyar/Payjama Section SwitchTile
                              if (clothItem['clothType'] == "সেলোয়ার" ||
                                  clothItem['clothType'] == "ধুতি সেলোয়ার" ||
                                  clothItem['clothType'] == "পায়জামা" ||
                                  clothItem['clothType'] == 'চোষা পায়জামা') ...[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('পকেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isPoket'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isPoket', value);
                                              // setState(() {
                                              //   _isPoket = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('চেইন',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isChain'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isChain', value);
                                              // setState(() {
                                              //   _isChain = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('২ পকেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['is2Pocket'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'is2Pocket', value);
                                              // setState(() {
                                              //   _is2Pocket = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('১ পকেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isOnePocket'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isOnePocket', value);
                                              // setState(() {
                                              //   _is2Pocket = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('মোটাসুতা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isMotaShuta'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isMotaShuta', value);
                                              // setState(() {
                                              //   _isMotaShuta = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('ডাবল সেলাই',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isDoubleSelai'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isDoubleSelai', value);
                                              // setState(() {
                                              //   _isDoubleSelai = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: SwitchListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: Text('মোবাইল পকেট',
                                              style: TextStyle(fontSize: 14)),
                                          value: clothItem['isMobilePocket'],
                                          onChanged: (value) {
                                            _updateClothItem(
                                                index, 'isMobilePocket', value);
                                            // setState(() {
                                            //   _isMobilePocket = value!;
                                            // });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SwitchListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: Text('পিছনে পকেট',
                                              style: TextStyle(fontSize: 14)),
                                          value: clothItem['isPichonePocket'],
                                          onChanged: (value) {
                                            _updateClothItem(index,
                                                'isPichonePocket', value);
                                            // setState(() {
                                            //   _isMobilePocket = value!;
                                            // });
                                          },
                                        ),
                                      ),
                                    ]),
                                  ],
                                )
                              ] else ...[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('বেন্ড রাউন্ড কলার',
                                                style: TextStyle(fontSize: 14)),
                                            value:
                                                clothItem['isBendRoundColar'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isBendRoundColar', value);
                                              // setState(() {
                                              //   _isBendRoundColar = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('২ পকেট চেইন',
                                                style: TextStyle(fontSize: 14)),
                                            value:
                                                clothItem['isTwoPocketChain'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isTwoPocketChain', value);
                                              // setState(() {
                                              //   _isBendRoundColar = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কটি কলার',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isKotiColar'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isKotiColar', value);
                                              // setState(() {
                                              //   _isKotiColar = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('ডাবল প্লেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isDoublePlate'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isDoublePlate', value);
                                              // setState(() {
                                              //   _isDoublePlate = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('রাউন্ড কলার',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isRoundcolar'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isRoundcolar', value);
                                              // setState(() {
                                              //   _isRoundcolar = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('সিঙ্গেল প্লেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isSinglePlate'],
                                            onChanged: (bool? value) {
                                              _updateClothItem(index,
                                                  'isSinglePlate', value);
                                              // setState(() {
                                              //   _isSinglePlate = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('ফুল',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isFull'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isFull', value);
                                              // setState(() {
                                              //   _isFull = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('সামনা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isSamna'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isSamna', value);
                                              // setState(() {
                                              //   _isSamna = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কলার',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isColar'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isColar', value);
                                              // setState(() {
                                              //   _isColar = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('মুরা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isMura'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isMura', value);
                                              // setState(() {
                                              //   _isMura = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('হাতা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isHata'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isHata', value);
                                              // setState(() {
                                              //   _isHata = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কপ',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isKop'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isKop', value);
                                              // setState(() {
                                              //   _isKop = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('সাইড পকেট',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isSidePocket'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isSidePocket', value);
                                              // setState(() {
                                              //   _isSidePocket = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কান্দি',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isKandi'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isKandi', value);
                                              // setState(() {
                                              //   _isKandi = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('ফুল বডি সিটা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isFullBodySita'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isFullBodySita', value);
                                              // setState(() {
                                              //   _isFullBodySita = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কলার সিঙ্গেল',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isColarSingle'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isColarSingle', value);
                                              // setState(() {
                                              //   _isColarSingle = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('কলার ডবল',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isColarDouble'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isColarDouble', value);
                                              // setState(() {
                                              //   _isColarDouble = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('সামনা সিটা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isSamnaSita'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isSamnaSita', value);
                                              // setState(() {
                                              //   _isSamnaSita = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('গোলগলা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isGolGola'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isGolGola', value);
                                              // setState(() {
                                              //   _isGolGola = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('১ চেইন',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isOneChain'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'isOneChain', value);
                                              // setState(() {
                                              //   _isOneChain = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('১ গুন্টিদানা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['isOneGuntiDana'],
                                            onChanged: (value) {
                                              _updateClothItem(index,
                                                  'isOneGuntiDana', value);
                                              // setState(() {
                                              //   _isOneGuntiDana = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text('৩ গুন্টি দানা',
                                                style: TextStyle(fontSize: 14)),
                                            value: clothItem['is3GuntiDana'],
                                            onChanged: (value) {
                                              _updateClothItem(
                                                  index, 'is3GuntiDana', value);
                                              // setState(() {
                                              //   _is3GuntiDana = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
//End Panjabi Section SwitchTile
                              // Add or Remove Cloth Item Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      // onPrimary: Colors.white,
                                    ),
                                    onPressed: _addClothItem,
                                    child: Text('Add Cloth Item'),
                                  ),
                                  (index + 1 > 1 || clothList.length >= 2)
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            // onPrimary: Colors.white,
                                          ),
                                          onPressed: () =>
                                              _removeClothItem(index),
                                          child: Text('Remove Cloth Item'),
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    //Elevated button for submit
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        //width of button

                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          backgroundColor: GlobalVariables.primaryColor,
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
                                title: Text('Order Updating...'),
                                content:
                                    // Text(
                                    //     'Order (${snapshot.data})  Created Successfully'),
                                    FutureBuilder<String>(
                                        future: updateOrder(
                                          _selectedCustomerName,
                                          _selectedCustomerPhone,
                                          _selectedCustomerLocation,
                                          _orderNote,
                                          _paidAmount,
                                          _estimatedDeliveryTime,
                                        ),
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
                                                ' Order ${order_ID} Updated Successfully ',
                                                style: TextStyle(fontSize: 13));
                                          }
                                        }),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      //material navigation to previous page
                                      Timer(
                                          const Duration(seconds: 1),
                                          () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NavbarScreen())));
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 500),
                                      //     () {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             OrdersOld()),
                                      //   );
                                      // });
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
                        child: Text('Update Details'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
