import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/restaurant.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/menu_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/cart_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/AppDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Restaurant> restaurants = []; // List to store fetched restaurants
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurants(); // Fetch restaurants from Firestore on screen initialization
  }

  void fetchRestaurants() async {
    List<Restaurant> fetchedRestaurants =
        await FirestoreService().readRestaurantData();
    setState(() {
      restaurants = fetchedRestaurants;
    });
  }

  void performSearch(String value) {
    setState(() {
      searchText = value;
    });
  }

  List<Restaurant> getFilteredRestaurants() {
    if (searchText.isEmpty) {
      return restaurants;
    } else {
      return restaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(searchText.toLowerCase()) ||
              restaurant.address.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
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
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Restaurants',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: performSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredRestaurants().length,
              itemBuilder: (context, index) {
                Restaurant restaurant = getFilteredRestaurants()[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(restaurant.name),
                    subtitle: Text(restaurant.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(restaurant.favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () async {
                            bool newFavoriteStatus = !restaurant.favorite;

                            // Update the favorite status in Firestore
                            await FirestoreService()
                                .updateRestaurantFavoriteStatus(
                              restaurant.uid,
                              newFavoriteStatus,
                            );

                            setState(() {
                              restaurant.favorite = newFavoriteStatus;
                            });
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MenuPage(restaurantId: restaurant.uid),
                              ),
                            );
                          },
                          child: Text('View Menu'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
