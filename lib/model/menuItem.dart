class MenuItem {
  String id;
  String name;
  double price;
  String restaurantId;
  String restaurantName; // Added property for restaurant name
  String description;
  bool favorite; // New field

  MenuItem({
    this.id,
    this.name,
    this.price,
    this.restaurantId,
    this.restaurantName,
    this.description,
    this.favorite = false, // Default to false
  });

  MenuItem.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    price = data['price'] ?? 0.0;
    restaurantId = data['restaurantId'];
    restaurantName = data['restaurantName'];
    description = data['description'];
    favorite = data['favorite'] ?? false; // Initialize favorite field with default value
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'description': description,
      'favorite': favorite, // Include favorite field in the map
    };
  }
}
