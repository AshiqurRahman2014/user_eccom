import 'package:flutter/material.dart';

class PromoCodePage extends StatelessWidget {
  static const String routeName = '/promocode';
  const PromoCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final code = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo code'),
      ),
      body: Center(
        child: Text(code,style: Theme.of(context).textTheme.headline6,),
      ),
    );
  }
}
