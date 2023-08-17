import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/profile.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _userProfile;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    // Get the current user's UID
    User user = FirebaseAuth.instance.currentUser;
    String uid = user.uid;

    // Fetch the user's profile from Firestore
    _userProfile = await FirestoreService().getUserProfile(uid);
    _displayNameController.text = _userProfile.displayName;
    _phoneNumberController.text = _userProfile.phoneNumber;
    setState(() {});
  }

  void _updateUserProfile() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    String updatedDisplayName = _displayNameController.text;
    String updatedPhoneNumber = _phoneNumberController.text;

    Profile updatedProfile = Profile(
      uid: uid,
      displayName: updatedDisplayName,
      phoneNumber: updatedPhoneNumber,
      email: _userProfile.email,
      points: _userProfile.points,
    );

    await FirestoreService().updateUserProfile(updatedProfile);

    // Refresh the user profile after update
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${_userProfile.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            Text(
              'Points: ${_userProfile.points}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
