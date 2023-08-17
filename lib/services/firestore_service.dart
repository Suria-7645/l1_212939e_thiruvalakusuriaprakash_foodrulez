import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/restaurant.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/menuItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/profile.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/cartItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/order.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/orderItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/rewards.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference menuItemCollection =
      FirebaseFirestore.instance.collection('menuItems');
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('userProfiles');
   final CollectionReference cartItemCollection =
      FirebaseFirestore.instance.collection('cartItems');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference orderItemCollection =
      FirebaseFirestore.instance.collection('orderItems');

   final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> redeemReward(String userId, String rewardId) async {
    try {
      await userProfileCollection.doc(userId).collection('redeemedRewards').doc(rewardId).set({
        'rewardId': rewardId,
        'redeemedDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle any errors
      print('Error redeeming reward: $e');
      throw e;
    }
  }

Future<List<Rewards>> getAllRewards() async {
    QuerySnapshot snapshot = await _db.collection('rewards').get();
    List<Rewards> rewardsList = [];

    snapshot.docs.forEach((doc) {
      Rewards reward = Rewards.fromMap(doc.data());
      reward.id = doc.id;
      rewardsList.add(reward);
    });

    return rewardsList;
  }

  Future<Rewards> getRewardById(String rewardId) async {
    DocumentSnapshot snapshot = await _db.collection('rewards').doc(rewardId).get();

    if (snapshot.exists) {
      Rewards reward = Rewards.fromMap(snapshot.data());
      reward.id = snapshot.id;
      return reward;
    } else {
      return null;
    }
  }
  Future<void> checkout(List<CartItem> cartItems) async {
    User user = _auth.currentUser;
    String userId = user.uid;

     double totalAmount = calculateTotalAmount(cartItems);
     int awardedPoints = (totalAmount * 10).toInt(); // Award 10 points for each dollar spent

      // Update user's profile with awarded points
     await updateUserPoints(userId, awardedPoints);

    // Create an order
    Order order = Order(
      userId: userId,
      orderDate: Timestamp.now().toDate(), // Set the order date to the current time
      totalPrice: calculateTotalAmount(cartItems), // Calculate the total amount of the order
    );

    // Add the order to Firestore and get the generated order ID
    var orderDocRef = await orderCollection.add(order.toMap());
      order.id = orderDocRef.id;
      await orderDocRef.set(order.toMap());
    String orderId = orderDocRef.id;

    // Create and add order items with the generated order ID
    for (var cartItem in cartItems) {
      OrderItem orderItem = OrderItem(
        orderId: orderId,
        userId: userId,
        menuItemId: cartItem.menuItemId,
        menuItemName: cartItem.menuItemName,
        menuItemPrice: cartItem.menuItemPrice,
        quantity: cartItem.quantity,
        totalPrice: cartItem.totalPrice,
      );

       var orderItemDocRef = await orderItemCollection.add(orderItem.toMap());
      orderItem.id = orderItemDocRef.id;
      await orderItemDocRef.set(orderItem.toMap());
    }

    // Remove cart items after checkout
    for (var cartItem in cartItems) {
      await _db.collection('cartItems').doc(cartItem.id).delete();
    }
  }
  Future<void> updateUserProfile(Profile updatedProfile) async {
    await userProfileCollection.doc(updatedProfile.uid).update({
      'displayName': updatedProfile.displayName,
      'phoneNumber': updatedProfile.phoneNumber,
    });
  }

  Future<void> updateUserPoints(String userId, int awardedPoints) async {
  // Get the current points of the user
  Profile userProfile = await getUserProfile(userId);

  if (userProfile != null) {
    int currentPoints = userProfile.points ?? 0;
    int updatedPoints = currentPoints + awardedPoints;

    await userProfileCollection.doc(userId).update({'points': updatedPoints});
  }
}

  double calculateTotalAmount(List<CartItem> cartItems) {
    double totalAmount = 0;
    for (var cartItem in cartItems) {
      totalAmount += cartItem.totalPrice;
    }
    return totalAmount;
  }


  Future<void> addCartItem(CartItem cartItem) async {
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser.uid;

    // Check if a cart item with the same menu item exists for the user
    CartItem existingCartItem = await getCartItemByUserAndMenuItem(userId, cartItem.menuItemId);

    if (existingCartItem != null) {
      // Update the existing cart item's quantity and total price
      existingCartItem.quantity += cartItem.quantity;
      existingCartItem.totalPrice += cartItem.totalPrice;

      await cartItemCollection.doc(existingCartItem.id).update(existingCartItem.toMap());
    } else {
      // Add a new cart item
      var docRef = await cartItemCollection.add(cartItem.toMap());
      cartItem.id = docRef.id;
      await docRef.set(cartItem.toMap());
    }
  }
  Future<CartItem> getCartItemByUserAndMenuItem(String userId, String menuItemId) async {
  QuerySnapshot snapshot = await cartItemCollection
      .where('userId', isEqualTo: userId)
      .where('menuItemId', isEqualTo: menuItemId)
      .get();

  if (snapshot.docs.isNotEmpty) {
    DocumentSnapshot document = snapshot.docs.first;
    return CartItem.fromMap(document.data());
  }

  return null;
}


  Future<List<CartItem>> getCartItemsByUser(String userId) async {
    List<CartItem> cartItems = [];
    QuerySnapshot snapshot = await cartItemCollection
        .where('userId', isEqualTo: userId)
        .get();

    snapshot.docs.forEach((document) {
      CartItem cartItem = CartItem.fromMap(document.data());
      cartItems.add(cartItem);
    });

    return cartItems;
  }
Future<List<CartItem>> getCartItems() async {
  String userId = FirebaseAuth.instance.currentUser.uid;

  List<CartItem> cartItems = [];

  QuerySnapshot snapshot = await cartItemCollection
      .where('userId', isEqualTo: userId)
      .get();

  snapshot.docs.forEach((document) {
    CartItem cartItem = CartItem.fromMap(document.data());
    cartItems.add(cartItem);
  });

  return cartItems;
}
  Future<void> deleteCartItem(String cartItemId) async {
    await cartItemCollection.doc(cartItemId).delete();
  }

  Future<void> addOrder(Order order) async {
    await orderCollection.doc(order.id).set(order.toMap());
  }

  Future<List<Order>> getOrdersByUser(String userId) async {
    List<Order> orders = [];
    QuerySnapshot snapshot = await orderCollection
        .where('userId', isEqualTo: userId)
        .get();

    snapshot.docs.forEach((document) {
      Order order = Order.fromMap(document.data());
      orders.add(order);
    });

    return orders;
  }

 Future<void> addOrderItem(OrderItem orderItem) async {
    var docRef = await orderItemCollection.add(orderItem.toMap());
    orderItem.id = docRef.id;
    await docRef.set(orderItem.toMap());
  }

  Future<List<OrderItem>> getOrderItemsByOrder(String orderId) async {
    QuerySnapshot snapshot = await orderItemCollection
        .where('orderId', isEqualTo: orderId)
        .get();

    List<OrderItem> orderItems = [];
    snapshot.docs.forEach((document) {
      OrderItem orderItem = OrderItem.fromMap(document.data());
      orderItems.add(orderItem);
    });

    return orderItems;
  }


  Future<void> addRestaurantData(
      String restaurantName, String restaurantAddress, String restaurantDescription) async {
    var docRef = restaurantCollection.doc();
    print('add docRef: ' + docRef.id);

    await docRef.set({
      'id': docRef.id,
      'name': restaurantName,
      'address': restaurantAddress,
      'description': restaurantDescription,
      'favorite': false, // Default to false
    });
  }
  Future<void> addUserProfile(Profile userProfile) async {
      await userProfileCollection.doc(userProfile.uid).set(userProfile.toMap());
    }

    Future<Profile> getUserProfile(String uid) async {
      DocumentSnapshot snapshot = await userProfileCollection.doc(uid).get();
      if (snapshot.exists) {
        return Profile.fromMap(snapshot.data());
      }
      return null;
    }
  
  Future<void> addMenuItemData(
      String itemName, double itemPrice, String restaurantId, String itemDescription) async {
    var docRef = menuItemCollection.doc();
    print('add menuItem docRef: ' + docRef.id);

    await docRef.set({
      'id': docRef.id,
      'name': itemName,
      'price': itemPrice,
      'restaurantId': restaurantId,
      'description': itemDescription,
      'favorite': false, // Default to false
    });
  }

  Future<List<Restaurant>> readRestaurantData() async {
    List<Restaurant> restaurantList = [];
    QuerySnapshot snapshot = await restaurantCollection.get();

    snapshot.docs.forEach((document) {
      Restaurant restaurant = Restaurant.fromMap(document.data());
      restaurantList.add(restaurant);
    });

    print('Restaurant List: $restaurantList');
    return restaurantList;
  }

  Future<List<MenuItem>> readMenuItems() async {
    List<MenuItem> menuItems = [];
    QuerySnapshot snapshot = await menuItemCollection.get();

    snapshot.docs.forEach((document) {
      MenuItem menuItem = MenuItem.fromMap(document.data());
      menuItems.add(menuItem);
    });

    print('Menu Items: $menuItems');
    return menuItems;
  }

  Future<void> deleteRestaurantData(String docId) async {
    restaurantCollection.doc(docId).delete();

    print('Deleting uid: $docId');
  }

  Future<void> deleteMenuItemData(String docId) async {
    menuItemCollection.doc(docId).delete();

    print('Deleting menuItem uid: $docId');
  }

  Future<Restaurant> getRestaurantById(String docId) async {
  DocumentSnapshot snapshot = await restaurantCollection.doc(docId).get();
  if (snapshot.exists) {
    return Restaurant.fromMap(snapshot.data());
  }
  return null;
}

Future<void> updateMenuItemData(
    String docId, String itemName, double itemPrice, String itemDescription) async {
  await menuItemCollection.doc(docId).update({
    'name': itemName,
    'price': itemPrice,
    'description': itemDescription,
  });
}
Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurantUId) async {
  List<MenuItem> menuItems = [];
  print('Query restaurantId: $restaurantUId'); // Debug print
  QuerySnapshot snapshot = await menuItemCollection
      .where('restaurantID', isEqualTo: restaurantUId)
      .get();

  print('Snapshot length: ${snapshot.size}'); // Debug print
  
  snapshot.docs.forEach((document) {
    MenuItem menuItem = MenuItem.fromMap(document.data());
    menuItems.add(menuItem);
  });

  print('Menu Items for Restaurant $restaurantUId: $menuItems');
  return menuItems;
}
Future<List<MenuItem>> getMenuItemsByRestaurantName(String restaurantName) async {
  List<MenuItem> menuItems = [];
  print('Query restaurantName: $restaurantName'); // Debug print
  QuerySnapshot snapshot = await menuItemCollection
      .where('restaurantName', isEqualTo: restaurantName)
      .get();

  print('Snapshot length: ${snapshot.size}'); // Debug print

  snapshot.docs.forEach((document) {
    MenuItem menuItem = MenuItem.fromMap(document.data());
    menuItems.add(menuItem);
  });

  print('Menu Items for Restaurant $restaurantName: $menuItems');
  return menuItems;
}

  Future<void> deleteRestaurantDoc() async {
    await restaurantCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
  Future<void> updateRestaurantFavoriteStatus(String docId, bool isFavorite) async {
    await restaurantCollection.doc(docId).update({
      'favorite': isFavorite,
    });
  }
  Future<void> updateMenuItemFavoriteStatus(String docId, bool isFavorite) async {
    await menuItemCollection.doc(docId).update({
      'favorite': isFavorite,
    });
  }
}
