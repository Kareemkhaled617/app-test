import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priject3/screens/personaldetails.dart';
import 'package:priject3/screens/signin.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // صورة صغيرة في الأعلى
          Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(
              child: Image.asset('assets/Vector.png', width: 100, height: 100),
            ),
          ),
          Container(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Larry Anderson',
                      style: TextStyle(
                        fontSize: 24,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalDetails()));
                  },
                  leading: Icon(Icons.person),
                  title: Text('Account Details'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Current package | Premium'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text('Contact us'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.rate_review),
                  title: Text('My Review'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Switch(value: true, onChanged: (value) {})],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign out'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/Frame 3.png', width: 200, height: 200),
              SizedBox(height: 16),
              Text(
                'Are You Sure You Want to Sign Out?',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Signin()));
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 65,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Yes, Sure',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel Now',
                      style: TextStyle(color: Color.fromRGBO(36, 133, 230, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
