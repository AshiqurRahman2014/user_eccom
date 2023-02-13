import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_ecomm/provider/cart_provider.dart';
import 'package:user_ecomm/uitls/constants.dart';

import '../curstomwidegt/cart_item_view.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cartpage';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).clearCart();
              },
              child: const Text('Clear'))
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: provider.cartList.length,
              itemBuilder: (context, index) {
                final cartModel = provider.cartList[index];
                return CartItemView(cartModel: cartModel,provider: provider);
              },
            )),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(child: Text('Subtotal: $currencySymbol${provider.getCartSubTotal()}',
                      style: Theme.of(context).textTheme.headline6,)),
                    OutlinedButton(onPressed: provider.cartList.isEmpty ? null :
                        (){
                          Navigator.pushNamed(context, CheckOutPage.routeName);
                        }, child: const Text('Checkout'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
