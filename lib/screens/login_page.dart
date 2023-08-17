import 'package:flutter/material.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/services/firebaseauth_service.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/home_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/addUserProfile.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('FoodRulez'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                signUp ? "Sign Up" : "Sign In",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () async {
                  if (signUp) {
                    var newuser = await FirebaseAuthService().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if (newuser != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AddUserProfileScreen()),
                      );
                    }
                  } else {
                    var reguser = await FirebaseAuthService().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if (reguser != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  }
                },
                child: signUp ? Text("Sign Up") : Text("Sign In"),
              ),
              SizedBox(height: 10),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    signUp = !signUp;
                  });
                },
                child: signUp
                    ? Text("Have an account? Sign In")
                    : Text("Create an account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
