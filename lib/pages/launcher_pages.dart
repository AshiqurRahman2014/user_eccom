import 'package:flutter/material.dart';
import 'package:user_ecomm/pages/view_product_page.dart';
import '../auth/auth_services.dart';
import 'login_pages.dart';

class LauncherPage extends StatelessWidget {
  static const String routeName = '/';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if(AuthService.currentUser != null) {
        Navigator.pushReplacementNamed(context, ViewProductPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
