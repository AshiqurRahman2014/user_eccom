import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:user_ecomm/models/address_model.dart';
import 'package:user_ecomm/models/date_model.dart';
import 'package:user_ecomm/models/order_model.dart';
import 'package:user_ecomm/pages/view_product_page.dart';
import 'package:user_ecomm/provider/order_provider.dart';
import 'package:user_ecomm/provider/user_provider.dart';
import 'package:user_ecomm/uitls/constants.dart';
import 'package:user_ecomm/uitls/helper_function.dart';

import '../auth/auth_services.dart';
import '../models/notification_model.dart';
import '../provider/cart_provider.dart';
import 'ordersuccessful_page.dart';

class CheckOutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final zipCodeController = TextEditingController();
  String? city;
  String paymentMethodGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    setAddressIsExists();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckOut Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(9),
        children: [
          buildHeader('Product Info'),
          buildProductInfoSystem(),
          buildHeader('Order Summery'),
          buildOrderSummerySection(),
          buildHeader('Delivery Address'),
          buildDeliveryAddressSection(),
          buildHeader('Payment Method'),
          buildPaymentMethodSection(),
          buildOrderButtonSection(),
        ],
      ),
    );
  }

  Padding buildHeader(String header) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: Text(
        header,
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget buildProductInfoSystem() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: cartProvider.cartList
              .map((cartModel) => ListTile(
                    title: Text(cartModel.productName),
                    trailing:
                        Text('${cartModel.quantity}x${cartModel.salePrice}'),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildOrderSummerySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Sub-total'),
              trailing:
                  Text('$currencySymbol${cartProvider.getCartSubTotal()}'),
            ),
            ListTile(
              title: Text(
                  'Didcount(${orderProvider.orderConstantModel.discount}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: Text('VAT(${orderProvider.orderConstantModel.vat}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: const Text('Delivary Charge'),
              trailing: Text(
                  '$currencySymbol${orderProvider.orderConstantModel.deliveryCharge}'),
            ),
            const Divider(
              color: Colors.black,
              height: 2,
            ),
            ListTile(
              title: const Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                  '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeliveryAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: addressLine1Controller,
              decoration: const InputDecoration(
                hintText: 'Address Line 1',
              ),
            ),
            TextField(
              controller: addressLine2Controller,
              decoration: const InputDecoration(
                hintText: 'Address Line 2',
              ),
            ),
            TextField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Zip Code',
              ),
            ),
            DropdownButton<String>(
              value: city,
              isExpanded: true,
              hint: const Text('Select your city'),
              items: cities
                  .map((city) =>
                      DropdownMenuItem<String>(value: city, child: Text(city)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  Widget buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Radio<String>(
              value: PaymentMethod.cod,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.cod),
            Radio<String>(
              value: PaymentMethod.online,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButtonSection() {
    return ElevatedButton(
      onPressed: _saveOrder,
      child: const Text('Place Order'),
    );
  }

  void _saveOrder() async{
    if (addressLine1Controller.text.isEmpty) {
      showMsg(context, 'Please provide address line 1');
      return;
    }
    if (zipCodeController.text.isEmpty) {
      showMsg(context, 'Please provide z ip code');
      return;
    }
    if (city == null) {
      showMsg(context, 'Please select your city');
      return;
    }
    EasyLoading.show(status: 'Please wait');

    final orderModel = OrderModel(
        orderId: generateOrderId,
        userId: AuthService.currentUser!.uid,
        orderStatus: OrderStatus.pending,
        paymentMethod: paymentMethodGroupValue,
        grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
        discount: orderProvider.orderConstantModel.discount,
        VAT: orderProvider.orderConstantModel.vat,
        deliveryCharge: orderProvider.orderConstantModel.deliveryCharge,
        orderDate: DateModel(
            timestamp: Timestamp.fromDate(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year),
        deliveryAddress: AddressModel(
            addressLine1: addressLine1Controller.text,
            addressLine2: addressLine2Controller.text,
            zipcode: zipCodeController.text,
            city: city),
        productDetails: cartProvider.cartList);


        try{
         await orderProvider.saveOrder(orderModel);
         final notification = NotificationModel(
           id: DateTime.now().millisecondsSinceEpoch.toString(),
           type: NotificationType.order,
           message: 'You have a new order #${orderModel.orderId}',
           orderModel: orderModel,
         );
         await orderProvider.addNotification(notification);
         EasyLoading.dismiss();
         Navigator.pushNamedAndRemoveUntil(context, OrderSuccessFulPage.routeName,
             ModalRoute.withName(ViewProductPage.routeName));
        }catch(error){
          EasyLoading.dismiss();
          showMsg(context, 'Failed to save order');
        }
  }

  void setAddressIsExists() {
    final userModel = userProvider.userModel;
    if (userModel != null) {
      if (userModel.addressModel != null) {
        final address = userModel.addressModel!;
        addressLine1Controller.text = address.addressLine1!;
        addressLine2Controller.text = address.addressLine2!;
        zipCodeController.text = address.zipcode!;
        city = address.city;
      }
    }
  }
}
