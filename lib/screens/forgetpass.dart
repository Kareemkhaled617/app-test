import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priject3/screens/signin.dart';

import 'details.dart';

class Forgetpass extends StatelessWidget {
  Forgetpass({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  void resetPassword(BuildContext context) async {
    if (passwordController.text != repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      // Reset the password using Firebase Auth
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!")),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Details())); // Navigate to login page after
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send reset email: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text('Create a new password'),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your Email',
                  ),
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'new password',
                  ),
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: repeatPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please, repeat new password',
                  ),
                ),
              ),
              SizedBox(height: 250),
              OutlinedButton(
                onPressed: () => resetPassword(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 160, vertical: 20),
                ),
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
