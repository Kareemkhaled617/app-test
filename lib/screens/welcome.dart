import 'package:flutter/material.dart';
import 'package:priject3/screens/homeScreen.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image.asset('assets/Frame 268.png'),
            SizedBox(height: 50),
            Text('We’ll see you inside'),
            SizedBox(height: 330),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 160, vertical: 20),
              ),
              child: Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
