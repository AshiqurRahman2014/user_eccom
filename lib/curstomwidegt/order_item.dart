import 'package:user_ecomm/models/order_model.dart';

class OrderItem{
  OrderModel orderModel;
  bool isExpanded;

  OrderItem({required this.orderModel, this.isExpanded=false});
}