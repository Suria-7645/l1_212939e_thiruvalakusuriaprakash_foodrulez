import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/About.jpg', // Replace with your image path
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Our App!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'We are a dedicated company committed to providing the best services to our users.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchPhoneApp('1234567890'), // Replace with your phone number
              child: Text('Contact Us (Phone)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _launchEmailApp('foodrulez@gmail.com'), // Replace with your email
              child: Text('Contact Us (Email)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneApp(String phoneNumber) async {
    final phoneUri = 'tel:$phoneNumber';
    if (await canLaunch(phoneUri)) {
      await launch(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _launchEmailApp(String emailAddress) async {
    final emailUri = 'mailto:$emailAddress';
    if (await canLaunch(emailUri)) {
      await launch(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(),
  ));
}
