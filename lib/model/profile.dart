class Profile {
  String uid; // User's unique identifier
  String displayName;
  String email;
  String phoneNumber;
  String photoUrl;
  int points; // New property with default value

  Profile({
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.points = 0, // Set default value to 0
  });

  Profile.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    displayName = data['displayName'];
    email = data['email'];
    phoneNumber = data['phoneNumber'];
    photoUrl = data['photoUrl'];
    points = data['points']; // Assign points from data
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'points': points, // Include points in the map
    };
  }
}
