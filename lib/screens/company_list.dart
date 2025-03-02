import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'feedback.dart';

class Company extends StatelessWidget {
  const Company({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Company'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: CompanyList(),
    );
  }
}

class CompanyList extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CompanyList({super.key});

  List company = [
    {
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/project-e8203.appspot.com/o/Mask%20group.png?alt=media&token=38c56733-8aaf-40ba-beef-de8a1a9b92dc',
      'name': 'IF JOE',
      'offer': 'Free Lalin Soap'
    },
    {
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/project-e8203.appspot.com/o/image%20664.png?alt=media&token=12c89085-aec0-4f5a-a5c2-ea5c248229c0',
      'name': 'Nail Art Studio',
      'offer': 'Free Manicure'
    },
    {
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/project-e8203.appspot.com/o/image%20665.png?alt=media&token=9b729df2-c0f5-41bb-9834-a4f948fb9528',
      'name': 'Pari Mas',
      'offer': '45% discount to brekfast'
    },
    {
      'logo':
          'https://plus.unsplash.com/premium_photo-1681487178876-a1156952ec60?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Q29tcGFuaWVzJTIwJTVDfGVufDB8fDB8fHww',
      'name': 'Pari Mas',
      'offer': '45% discount to brekfast'
    },
    {
      'logo':
          'https://firebasestorage.googleapis.com/v0/b/project-e8203.appspot.com/o/image%20666.png?alt=media&token=5c69ec1d-5296-4d69-92f4-1990f8bb228f',
      'name': 'Pencil',
      'offer': '23% discountto brand book'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('companies').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return CompanyCard(
              logo: data.docs[index]['logo'],
              name: data.docs[index]['name'],
              offer: data.docs[index]['offer'],
            );
          },
        );
      },
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String logo;
  final String name;
  final String offer;

  const CompanyCard(
      {super.key, required this.logo, required this.name, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FeedbackScreen(
                        image: logo,
                        name: name,
                        isEdit: false,
                      )));
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(logo),
        ),
        title: Text(name),
        subtitle: Text(offer),
      ),
    );
  }
}
