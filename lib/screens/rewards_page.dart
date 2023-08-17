import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/rewards.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/model/profile.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  List<Rewards> rewardsList = [];
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    fetchRewards();
    fetchUserPoints();
  }

  void fetchRewards() async {
    List<Rewards> fetchedRewards = await FirestoreService().getAllRewards();
    setState(() {
      rewardsList = fetchedRewards;
    });
  }

  void fetchUserPoints() async {
    // Get the current user's UID
    User user = FirebaseAuth.instance.currentUser;
    String uid = user.uid;

    // Fetch the user's profile from Firestore to get points
    Profile userProfile = await FirestoreService().getUserProfile(uid);
    setState(() {
      userPoints = userProfile.points;
    });
  }
  void _handleRedeem(Rewards reward) async {
    // Check if user has enough points to redeem the reward
    if (userPoints >= reward.pointsRequired) {
      // Deduct the points from user's total points
      int updatedUserPoints = userPoints - reward.pointsRequired;

      // Get the current user's UID
      User user = FirebaseAuth.instance.currentUser;
      String uid = user.uid;

      // Update user's points in Firestore
      await FirestoreService().updateUserPoints(uid, updatedUserPoints);

      // Update the userPoints in the state
      setState(() {
        userPoints = updatedUserPoints;
      });

      // You can also update a separate collection to keep track of redeemed rewards
      await FirestoreService().redeemReward(uid, reward.id);

      // Show a confirmation dialog or toast message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reward Redeemed'),
            content: Text('You have successfully redeemed ${reward.name}.'),
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
      // Show an error message if user doesn't have enough points
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Points'),
            content: Text('You do not have enough points to redeem this reward.'),
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
        title: Text('Rewards'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Points: $userPoints',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rewardsList.length,
              itemBuilder: (context, index) {
                Rewards reward = rewardsList[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(reward.name),
                    subtitle: Text('Points required: ${reward.pointsRequired}'),
                    trailing: ElevatedButton(
                      onPressed: userPoints >= reward.pointsRequired
                          ? () {
                              // Handle redeem logic here
                              _handleRedeem(reward); // Call the _handleRedeem method
                            }
                          : null,
                      child: Text('Redeem'),
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