import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firebaseauth_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/profile.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/home_page.dart';

class AddUserProfileScreen extends StatefulWidget {
  @override
  _AddUserProfileScreenState createState() => _AddUserProfileScreenState();
}

class _AddUserProfileScreenState extends State<AddUserProfileScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String email = ''; // Add this field

  @override
  void initState() {
    super.initState();
    fetchUserEmail(); // Fetch user's email on screen initialization
  }

  void fetchUserEmail() async {
    String userEmail = await FirebaseAuthService().getCurrentUserEmail();
    setState(() {
      email = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(text: email), // Pre-fill email field
              decoration: InputDecoration(labelText: 'Email'),
              enabled: false, // Disable editing
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String currentUserUid = FirebaseAuthService().getCurrentUserUid();
                Profile userProfile = Profile(
                  uid: currentUserUid,
                  displayName: displayNameController.text,
                  email: email, // Use the pre-filled email
                  phoneNumber: phoneNumberController.text,
                );
                await FirestoreService().addUserProfile(userProfile);

                // Navigate to the homepage screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Replace with your homepage screen
                );
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
