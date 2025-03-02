import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'feedback.dart';

class ReviewHistoryScreen extends StatefulWidget {
  const ReviewHistoryScreen({super.key});

  @override
  _ReviewHistoryScreenState createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Review History'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData) {
            List reviews = snapshot.data!.docs;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review['date'],
                              style: TextStyle(fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FeedbackScreen(
                                              image: review['company'],
                                              name: review['name'],
                                              isEdit: true,
                                              id: review['id'],
                                              rate: review['rating'],
                                              comment: review['comment'],
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.greenAccent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.greenAccent),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('feedback')
                                    .doc(review['id'])
                                    .delete();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.redAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.network(review['imageUrl'],
                                    width: 100, height: 100)),
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  review['name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  review['comment'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                                Container(
                                  width: 80,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.yellowAccent,
                                      ),
                                      Text(
                                        review['rating'].toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No reviews found'));
          }
        },
      ),
    );
  }
}

class Review {
  final String id;
  final String title;
  final String content;
  final int rating;
  final DateTime date;
  final String imageUrl;

  Review({
    required this.id,
    required this.title,
    required this.content,
    required this.rating,
    required this.date,
    required this.imageUrl,
  });

  factory Review.fromFirestore(Map<String, dynamic> doc) {
    return Review(
      id: '',
      title: doc['name'],
      content: doc['comment'],
      rating: doc['rating'],
      date: DateTime.parse(doc['date']),
      imageUrl: doc['imageUrl'],
    );
  }
}
