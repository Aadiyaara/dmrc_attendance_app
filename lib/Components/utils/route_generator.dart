import 'package:flutter/material.dart';
import '../../main.dart';

//// Routing
import '../Auth/LoginPage.dart';
import '../Supervisor/Supervisor.dart';
import '../Admin/Admin.dart';
import '../Admin/AddSupervisor.dart';
import '../Admin/Attendance.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/supervisor':
        return MaterialPageRoute(builder: (_) => Supervisor());
      case '/admin':
        return MaterialPageRoute(builder: (_) => Admin());
      case '/auth':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/addsupervisor':
        return MaterialPageRoute(builder: (_) => AddSupervisor());
      case '/attendance':
        return MaterialPageRoute(builder: (_) => Attendance(data: args));
      default:
        return _errorRoute();
    }

  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error 404 Not Found'),
        ),
      );
    });
  }

}