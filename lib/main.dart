import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:user_ecomm/pages/cart_page.dart';
import 'package:user_ecomm/pages/checkout_page.dart';
import 'package:user_ecomm/pages/launcher_pages.dart';
import 'package:user_ecomm/pages/login_pages.dart';
import 'package:user_ecomm/pages/order_page.dart';
import 'package:user_ecomm/pages/ordersuccessful_page.dart';
import 'package:user_ecomm/pages/otp_verification_page.dart';
import 'package:user_ecomm/pages/product_details_pages.dart';
import 'package:user_ecomm/pages/promo_code_page.dart';
import 'package:user_ecomm/provider/cart_provider.dart';
import 'package:user_ecomm/provider/order_provider.dart';
import 'package:user_ecomm/provider/product_provider.dart';
import 'package:user_ecomm/provider/user_provider.dart';
import 'package:user_ecomm/uitls/notification_services.dart';

import 'pages/user_profile_page.dart';
import 'pages/view_product_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.toMap()}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationServices();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.subscribeToTopic("promo");
  await FirebaseMessaging.instance.subscribeToTopic("user");
  //print('Your FCM Token IS.........................: $fcmToken');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        OtpVerificationPage.routeName: (_) => const OtpVerificationPage(),
        CartPage.routeName: (_) => const CartPage(),
        CheckOutPage.routeName: (_) => const CheckOutPage(),
        OrderSuccessFulPage.routeName: (_) => const OrderSuccessFulPage(),
        OrderSuccessFulPage.routeName: (_) => const PromoCodePage(),
      },
    );
  }
}
