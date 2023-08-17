class Restaurant {
  String uid;
  String name;
  String address;
  String description;
  bool favorite; // New field

  Restaurant({
    this.uid,
    this.name,
    this.address,
    this.description,
    this.favorite = false, // Default to false
  });

  Restaurant.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    name = data['name'];
    address = data['address'];
    description = data['description'];
    favorite = data['favorite'] ?? false; // Initialize favorite field with default value
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'description': description,
      'favorite': favorite, // Include favorite field in the map
    };
  }
}
