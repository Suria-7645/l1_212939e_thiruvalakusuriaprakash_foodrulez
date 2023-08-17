import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/menuItem.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/cart_details.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/cart_page.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;

  MenuPage({this.restaurantId});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  void fetchMenuItems() async {
    List<MenuItem> fetchedMenuItems =
        await FirestoreService().getMenuItemsByRestaurant(widget.restaurantId);
    setState(() {
      menuItems = fetchedMenuItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Items'),
         actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
          ),
        ],
      ),
  body: ListView.builder(
  itemCount: menuItems.length,
  itemBuilder: (context, index) {
    MenuItem menuItem = menuItems[index];
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(menuItem.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menuItem.description),
            SizedBox(height: 4),
            Text('\$${menuItem.price.toStringAsFixed(2)}'),
          ],
        ),
        trailing: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartDetailsScreen(menuItem: menuItem),
              ),
            );
          },
          child: Text('Add to Cart'),
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  },
),



    );
  }
}
