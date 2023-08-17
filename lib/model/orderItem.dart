class OrderItem {
  String id;
  String orderId; // New property
  String userId;
  String menuItemId;
  String menuItemName;
  double menuItemPrice;
  int quantity;
  double totalPrice;

  OrderItem({
    this.id,
    this.orderId, // Initialize the orderId
    this.userId,
    this.menuItemId,
    this.menuItemName,
    this.menuItemPrice,
    this.quantity,
    this.totalPrice,
  });

  OrderItem.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    orderId = data['orderId']; // Assign orderId from data
    userId = data['userId'];
    menuItemId = data['menuItemId'];
    menuItemName = data['menuItemName'];
    menuItemPrice = data['menuItemPrice'];
    quantity = data['quantity'];
    totalPrice = data['totalPrice'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId, // Include orderId in the map
      'userId': userId,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'menuItemPrice': menuItemPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
