import 'package:cloud_firestore/cloud_firestore.dart'; 

class Order {
  String id;
  String userId;
  double totalPrice;
  DateTime orderDate;

  Order({
    this.id,
    this.userId,
    this.totalPrice,
    this.orderDate,
  });

  Order.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    userId = data['userId'];
    totalPrice = data['totalPrice'];
    orderDate = (data['orderDate'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
    };
  }
}
