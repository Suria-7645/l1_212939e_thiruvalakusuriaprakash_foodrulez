import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/cartItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser.uid;

    List<CartItem> fetchedCartItems =
        await FirestoreService().getCartItemsByUser(userId);
    setState(() {
      cartItems = fetchedCartItems;
    });
  }

  void deleteCartItem(String cartItemId) async {
    await FirestoreService().deleteCartItem(cartItemId);
    fetchCartItems(); // Refresh the list after deletion
  }

  void checkout() async {
    if (cartItems.isNotEmpty) {
      // Perform checkout and remove cart items
      await FirestoreService().checkout(cartItems);
      setState(() {
        cartItems.clear();
      });

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Successful'),
            content: Text('Your order has been placed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show a message if cart is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cart Empty'),
            content: Text('Your cart is empty.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          CartItem cartItem = cartItems[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(cartItem.menuItemName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: ${cartItem.quantity}'),
                  Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteCartItem(cartItem.id);
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: checkout,
            child: Text('Checkout - \$${calculateTotalAmount(cartItems).toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

  double calculateTotalAmount(List<CartItem> cartItems) {
    double totalAmount = 0;
    for (var cartItem in cartItems) {
      totalAmount += cartItem.totalPrice;
    }
    return totalAmount;
  }
}
