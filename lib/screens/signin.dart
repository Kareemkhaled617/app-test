import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priject3/screens/company_list.dart';
import 'package:priject3/screens/welcome.dart';

import 'forgetpass.dart';

class Signin extends StatelessWidget {
  Signin({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both email and password')),
        );
        return;
      }

      // Perform the Firebase sign-in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the next screen if successful
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Welcome())); // Change '/home' to your home route
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${e.message}')),
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
              Text('Sign into your account'),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _emailController,
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
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your password',
                  ),
                ),
              ),
              SizedBox(height: 280),
              OutlinedButton(
                onPressed: () => signInWithEmailAndPassword(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 160, vertical: 20),
                ),
                child: Text('Sign in', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 50),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Forgetpass()));
                  },
                  child: Text('Forgot your password?')),
            ],
          ),
        ),
      ),
    );
  }
}
