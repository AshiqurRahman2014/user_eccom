
import 'package:flutter/material.dart';
import 'package:user_ecomm/auth/auth_services.dart';
import 'package:user_ecomm/models/notification_model.dart';
import 'package:user_ecomm/models/order_model.dart';

import '../curstomwidegt/order_item.dart';
import '../db/db_helper.dart';
import '../models/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> orderList = [];
  List<OrderItem> orderItemList = [];

  getOrdersByUser() {
    DbHelper.getOrderByUserId(AuthService.currentUser!.uid).listen((snapshot) {
      orderList = List.generate(snapshot.docs.length, (index) => 
      OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();

      orderItemList = orderList.map((order) => OrderItem(orderModel: order)).toList();
      notifyListeners();
    });
  }

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((snapshot) {
      if(snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateOrderConstants(OrderConstantModel model) {
    return DbHelper.updateOrderConstants(model);
  }

  int getDiscountAmount(num subtotal){
    return ((subtotal * orderConstantModel.discount)/100).round();
  }

  int getVatAmount(num cartSubTotal) {
    final priceAfterDiscount = cartSubTotal - getDiscountAmount(cartSubTotal);
    return((priceAfterDiscount * orderConstantModel.vat) / 100).round();
  }

  int getGrandTotal(num cartSubTotal) {
    return ((cartSubTotal - getDiscountAmount(cartSubTotal)) +
    getVatAmount(cartSubTotal) + orderConstantModel.deliveryCharge).round();
  }

  Future<void> saveOrder(OrderModel orderModel) async{
    await DbHelper.saveOrder(orderModel);
    return DbHelper.clearCart(orderModel.userId, orderModel.productDetails);
  }

 Future<void> addNotification(NotificationModel notification) {
    return DbHelper.addNoticfication(notification);
  }
}