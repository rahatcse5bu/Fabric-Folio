// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nuriya_tailers/constants/utils.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, 'Please provide a valid Username and password');
      break;
    case 500:
      showSnackBar(context, 'Please provide a valid Username and password');
      break;
    default:
      showSnackBar(context, 'Please provide a valid Username and password');
  }
}
