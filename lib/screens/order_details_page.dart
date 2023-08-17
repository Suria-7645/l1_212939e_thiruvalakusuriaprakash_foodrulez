import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/order.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/orderItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  OrderDetailsPage({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: FirestoreService().getOrderItemsByOrder(order.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading order items.'));
         } else if (!snapshot.hasData || (snapshot.data != null && snapshot.data.isEmpty)) {
            return Center(child: Text('No order items available.'));
          } else {
           List<OrderItem> orderItems = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                OrderItem orderItem = orderItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(orderItem.menuItemName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${orderItem.quantity.toString()}'),
                        Text('Total Price: \$${orderItem.totalPrice.toStringAsFixed(2)}'),
                        // Add more details if needed
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
