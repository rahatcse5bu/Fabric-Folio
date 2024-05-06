import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/colors.dart';

import 'OrdersOld.dart';

class addOrderOld extends StatefulWidget {
  const addOrderOld({super.key});

  @override
  State<addOrderOld> createState() => _addOrderOldState();
}

class _addOrderOldState extends State<addOrderOld> {
  List<Map<String, dynamic>> customers = [];
// String selectedCustomerId = '';
//my variables starts
  final _formKey = GlobalKey<FormState>();
  String selectedCustomerId = '64ae9f6d559978be96f6c33b';
  String _selectedCustomer = 'Sujan';
  String _orderNote = 'Nothing';
  String _clothName = 'Nothing';
  String _clothType = 'ফতুয়া';
  double _paidAmount = 40.0;
  double _price = 40.0;

  DateTime _estimatedDeliveryTime = DateTime.now();
  String _lomba = '';
  String _payerMuhri = '';
  String _hatarMuhri = '';
  String _hiegh = '';
  String _puuti = '';
  String _bodyi = '';
  String _haatai = '';
  String _colarToyrii = '';
  String _komor = '';
  bool _isPoket = false;
  bool _isChain = false;
  bool _isMotaShuta = false;
  bool _isDoubleSelai = false;
  bool _isMotaRabar = false;
  bool _is2Pocket = false;
  bool _isMobilePocket = false;
  bool _isBendRoundColar = false;
  bool _isKotiColar = false;
  bool _isDoublePlate = false;
  bool _isRoundcolar = false;
  bool _isSinglePlate = false;
  bool _isFull = false;
  bool _isSamna = false;
  bool _isColar = false;
  bool _isMura = false;
  bool _isHata = false;
  bool _isKop = false;
  bool _isSidePocket = false;
  bool _isKandi = false;
  bool _isFullBodySita = false;
  bool _isColarSingle = false;
  bool _isColarDouble = false;
  bool _isSamnaSita = false;
  bool _isGolGola = false;
  bool _isOneChain = false;
  bool _isOneGuntiDana = false;
  bool _is3GuntiDana = false;
  //my variables ends
  var orderId = 'Error';

  Future<String> createOrder(
    String customerId,
    String orderNote,
    String clothName,
    String clothType,
    double paidAmount,
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
        'paidAmount': paidAmount,
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
      }),
      headers: {'Content-Type': 'application/json'},
    );

    var myJSON = jsonEncode({
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
    // print(customerId + "Cust IDDDDDDD");
    // print(myJSON.toString());
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
  void initState() {
    super.initState();
    fetchCustomers().then((value) {
      setState(() {
        customers = value;
        if (customers.isNotEmpty) {
          _selectedCustomer = customers[0]['customerName'];
          selectedCustomerId = customers[0]['_id'];
        }
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
        title: Text('Add Order'),
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
                    // DropdownButtonFormField(
                    //   borderRadius: BorderRadius.circular(8),
                    //   value: _selectedCustomer,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedCustomer = value.toString();
                    //       final selectedCustomer = customers.firstWhere(
                    //           (customer) =>
                    //               customer['customerName'] ==
                    //               _selectedCustomer);
                    //       selectedCustomerId = selectedCustomer['_id'];
                    //     });
                    //   },
                    //   items: customers.map((customer) {
                    //     return DropdownMenuItem(
                    //       value: customer['customerName'],
                    //       child: Text(customer['customerName']),
                    //     );
                    //   }).toList(),
                    //   decoration: InputDecoration(
                    //     labelText: 'কাস্টমার নির্বাচন করুন',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),
                    //   ),
                    // ),

                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: customers
                          .map<String>((customer) => customer['customerName'])
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'কাস্টমার নির্বাচন করুন',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onChanged: (String? selectedCustomer) {
                        setState(() {
                          _selectedCustomer = selectedCustomer!;
                          final selectedCustomerObj = customers.firstWhere(
                            (customer) =>
                                customer['customerName'] == _selectedCustomer,
                          );
                          selectedCustomerId = selectedCustomerObj['_id'];
                        });
                      },
                      selectedItem: _selectedCustomer,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
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
                          _orderNote = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        setState(() {
                          _clothName = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: _clothType,
                      onChanged: (value) {
                        setState(() {
                          _clothType = value.toString();
                        });
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'দাম',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _price = double.parse(value);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
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
                                _paidAmount = double.parse(value);
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
                            decoration: InputDecoration(
                                labelText: 'লম্বা',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _lomba = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'পায়ের মুহরি',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _payerMuhri = value;
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
                            decoration: InputDecoration(
                                labelText: 'হাতার মুহরি',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _hatarMuhri = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'হাই',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _hiegh = value;
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
                            decoration: InputDecoration(
                                labelText: 'পুটি',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _puuti = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'বডি',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _bodyi = value;
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
                            decoration: InputDecoration(
                                labelText: 'হাতাই',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _haatai = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'কলার তৈরি',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _colarToyrii = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'কোমর',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _komor = value;
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
                                style: TextStyle(fontSize: 12)),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _estimatedDeliveryTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              );
                              if (picked != null &&
                                  picked != _estimatedDeliveryTime) {
                                setState(() {
                                  _estimatedDeliveryTime = picked;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('পকেট'),
                            value: _isPoket,
                            onChanged: (value) {
                              setState(() {
                                _isPoket = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('চেইন'),
                            value: _isChain,
                            onChanged: (value) {
                              setState(() {
                                _isChain = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('মোটাসুতা'),
                            value: _isMotaShuta,
                            onChanged: (value) {
                              setState(() {
                                _isMotaShuta = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('ডাবল সেলাই'),
                            value: _isDoubleSelai,
                            onChanged: (value) {
                              setState(() {
                                _isDoubleSelai = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('মোটা রাবার'),
                            value: _isMotaRabar,
                            onChanged: (value) {
                              setState(() {
                                _isMotaRabar = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('২ পকেট'),
                            value: _is2Pocket,
                            onChanged: (value) {
                              setState(() {
                                _is2Pocket = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('মোবাইল পকেট'),
                            value: _isMobilePocket,
                            onChanged: (value) {
                              setState(() {
                                _isMobilePocket = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('বেন্ড রাউন্ড কলার'),
                            value: _isBendRoundColar,
                            onChanged: (value) {
                              setState(() {
                                _isBendRoundColar = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কটি কলার'),
                            value: _isKotiColar,
                            onChanged: (value) {
                              setState(() {
                                _isKotiColar = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('ডাবল প্লেট'),
                            value: _isDoublePlate,
                            onChanged: (value) {
                              setState(() {
                                _isDoublePlate = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('রাউন্ড কলার'),
                            value: _isRoundcolar,
                            onChanged: (value) {
                              setState(() {
                                _isRoundcolar = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('সিঙ্গেল প্লেট'),
                            value: _isSinglePlate,
                            onChanged: (bool? value) {
                              setState(() {
                                _isSinglePlate = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('ফুল'),
                            value: _isFull,
                            onChanged: (value) {
                              setState(() {
                                _isFull = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('সামনা'),
                            value: _isSamna,
                            onChanged: (value) {
                              setState(() {
                                _isSamna = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কলার'),
                            value: _isColar,
                            onChanged: (value) {
                              setState(() {
                                _isColar = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('মুরা'),
                            value: _isMura,
                            onChanged: (value) {
                              setState(() {
                                _isMura = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('হাতা'),
                            value: _isHata,
                            onChanged: (value) {
                              setState(() {
                                _isHata = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কপ'),
                            value: _isKop,
                            onChanged: (value) {
                              setState(() {
                                _isKop = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('সাইড পকেট'),
                            value: _isSidePocket,
                            onChanged: (value) {
                              setState(() {
                                _isSidePocket = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কান্দি'),
                            value: _isKandi,
                            onChanged: (value) {
                              setState(() {
                                _isKandi = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('ফুল বডি সিটা'),
                            value: _isFullBodySita,
                            onChanged: (value) {
                              setState(() {
                                _isFullBodySita = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কলার সিঙ্গেল'),
                            value: _isColarSingle,
                            onChanged: (value) {
                              setState(() {
                                _isColarSingle = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('কলার ডবল'),
                            value: _isColarDouble,
                            onChanged: (value) {
                              setState(() {
                                _isColarDouble = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('সামনা সিটা'),
                            value: _isSamnaSita,
                            onChanged: (value) {
                              setState(() {
                                _isSamnaSita = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('গোলগলা'),
                            value: _isGolGola,
                            onChanged: (value) {
                              setState(() {
                                _isGolGola = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('১ চেইন'),
                            value: _isOneChain,
                            onChanged: (value) {
                              setState(() {
                                _isOneChain = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('১ গুন্টিদানা'),
                            value: _isOneGuntiDana,
                            onChanged: (value) {
                              setState(() {
                                _isOneGuntiDana = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('৩ গুন্টি দানা'),
                            value: _is3GuntiDana,
                            onChanged: (value) {
                              setState(() {
                                _is3GuntiDana = value!;
                              });
                            },
                          ),
                        ),
                      ],
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
                                title: Text('Order Creating...'),
                                content:
                                    // Text(
                                    //     'Order (${snapshot.data})  Created Successfully'),
                                    FutureBuilder<String>(
                                        future: createOrder(
                                          selectedCustomerId,
                                          // '64ae9f6d559978be96f6c33b',
                                          _orderNote,
                                          _clothName,
                                          _clothType,
                                          _paidAmount,
                                          _price,
                                          _estimatedDeliveryTime,
                                          _lomba,
                                          _payerMuhri,
                                          _hatarMuhri,
                                          _hiegh,
                                          _puuti,
                                          _bodyi,
                                          _haatai,
                                          _colarToyrii,
                                          _komor,
                                          _isPoket,
                                          _isChain,
                                          _isMotaShuta,
                                          _isDoubleSelai,
                                          _isMotaRabar,
                                          _is2Pocket,
                                          _isMobilePocket,
                                          _isBendRoundColar,
                                          _isKotiColar,
                                          _isDoublePlate,
                                          _isRoundcolar,
                                          _isSinglePlate,
                                          _isFull,
                                          _isSamna,
                                          _isColar,
                                          _isMura,
                                          _isHata,
                                          _isKop,
                                          _isSidePocket,
                                          _isKandi,
                                          _isFullBodySita,
                                          _isColarSingle,
                                          _isColarDouble,
                                          _isSamnaSita,
                                          _isGolGola,
                                          _isOneChain,
                                          _isOneGuntiDana,
                                          _is3GuntiDana,
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
                                                ' Order ${order_ID} Created Successfully ',
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
                                                  OrdersOld()),
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
                        child: Text('Add Details'),
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
