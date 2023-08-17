import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/about_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/home_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/login_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/profile_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/orders_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/profile.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/rewards_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
         DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder<Profile>(
              future: FirestoreService().getUserProfile(FirebaseAuth.instance.currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(
                    'Welcome, ${snapshot.data.displayName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  );
                } else {
                  return Text(
                    'Welcome to FoodRulez',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 8),
            Text(
              'FoodRulez Member',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement( // Navigate to the Home page
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsPage(), // Navigate to the About Us page
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(), 
                ),
               );
                // Navigate to the profile page
            },
          ),
          ListTile(
            leading: Icon(Icons.history), // Icon for the Orders Page
            title: Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.redeem),
            title: Text('Redeem Rewards'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to redeem rewards page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),       // Add more ListTiles for other options
            ],
      ),
    );
  }
}