import 'package:flutter/material.dart';
import 'package:priject3/screens/signin.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image.asset('assets/Frame.png'),
            SizedBox(height: 50),
            Text('Details updated!'),
            SizedBox(height: 330),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signin()));
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 160, vertical: 20),
              ),
              child: Text('Sign in', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
