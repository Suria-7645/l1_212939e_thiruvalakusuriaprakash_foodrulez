class CartItem {
  String id;
  String userId;
  String menuItemId;
  String menuItemName;
  double menuItemPrice;
  int quantity;
  double totalPrice; // New property

  CartItem({
    this.id,
    this.userId,
    this.menuItemId,
    this.menuItemName,
    this.menuItemPrice,
    this.quantity,
    this.totalPrice, // Initialize the totalPrice
  });

  CartItem.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    userId = data['userId'];
    menuItemId = data['menuItemId'];
    menuItemName = data['menuItemName'];
    menuItemPrice = data['menuItemPrice'];
    quantity = data['quantity'];
    totalPrice = data['totalPrice']; // Assign totalPrice from data
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'menuItemPrice': menuItemPrice,
      'quantity': quantity,
      'totalPrice': totalPrice, // Include totalPrice in the map
    };
  }
}