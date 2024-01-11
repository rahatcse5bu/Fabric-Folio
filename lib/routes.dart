// ignore_for_file: non_constant_identifier_names, no_duplicate_case_values

import 'package:flutter/material.dart';
import 'package:nuriya_tailers/Dashboard/dashboard.dart';
import 'package:nuriya_tailers/features/auth/screens/auth_screen.dart';

// ignore: avoid_types_as_parameter_names
Route<dynamic> generateRoute(RouteSettings, routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case DashboardScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => DashboardScreen());
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text('Screen does not exist ')),
              ));
  }
}
