const String firebaseStorageProductImageDir = 'ProductImages';
const String currencySymbol = '৳';

const cities = [
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Khulna',
  'Barishal',
  'Sylhet',
  'Comilla',
  'Noakhali',
  'Faridpur',
  'Rangpur',
  'Gopalgonj'
];

abstract class OrderStatus{
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String retured = 'Retured';
}

abstract class PaymentMethod{
  static const String cod = 'Cash on Deliverey';
  static const String online = 'Online Payment';
}

abstract class NotificationType{
  static const String comment = 'New Comment';
  static const String order ='New Order';
  static const String user = 'New User';
}