import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/menuItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/cartItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';

class CartDetailsScreen extends StatefulWidget {
  final MenuItem menuItem;

  CartDetailsScreen({this.menuItem});

  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  int quantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.menuItem.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.menuItem.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Price: \$${widget.menuItem.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Select Quantity:'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Total Price: \$${(widget.menuItem.price * quantity).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Get the current user's ID
                String userId = FirebaseAuth.instance.currentUser.uid;

                CartItem cartItem = CartItem(
                  userId: userId,
                  menuItemId: widget.menuItem.id,
                  menuItemName: widget.menuItem.name,
                  menuItemPrice: widget.menuItem.price,
                  quantity: quantity,
                  totalPrice: widget.menuItem.price * quantity,
                );

                // Add the cart item to Firestore
                await FirestoreService().addCartItem(cartItem);

                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Item added to cart'),
                      content: Text('The item has been added to your cart.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
