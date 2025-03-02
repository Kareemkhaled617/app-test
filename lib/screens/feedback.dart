import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.isEdit,
      this.id,
      this.comment,
      this.rate});

  final String image;
  final String name;
  String? id;
  String? comment;
  double? rate;
  final bool isEdit;

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadFeedback() async {
    print('ededededed');
    String imageUrl = '';
    print(_image!.path);
    // Check if an image is selected
    if (_image != null) {
      File file = File(_image!.path);

      // Create a reference to Firebase storage
      String fileName =
          'feedback_images/${DateTime.now().millisecondsSinceEpoch}_${_image!.name}';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      try {
        // Upload the file
        UploadTask uploadTask = ref.putFile(file);

        // Retrieve the URL of the uploaded image
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        // Handle errors
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
        return;
      }
    }
    String id = FirebaseFirestore.instance.collection('feedback').doc().id;
    // Upload other feedback data along with the image URL
    try {
      await FirebaseFirestore.instance.collection('feedback').doc(id).set({
        'rating': _rating,
        'id': id,
        'company': widget.image,
        'comment': _commentController.text,
        'name': widget.name,
        'date': DateFormat('MMM dd h:mm a').format(DateTime.now()),
        'imageUrl': imageUrl, // Include the image URL in the document
      });
    } catch (e) {
      print('Error uploading feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading feedback: $e')),
      );
    }

    // Navigate back or show a success message
    Navigator.pop(context);
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void showCustomDialog(
      BuildContext context, String image, String title, String supTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image, width: 150),
                SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  supTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Rate Now'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.isEdit) {
      _rating = widget.rate!;
      _commentController.text = widget.comment!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Well, how satisfied were you?',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Center(
              child: Image.network(
                  widget.image), // Replace with your network image
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type comment here..',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Upload image'),
                ),
                SizedBox(width: 10),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(File(_image!.path), width: 100),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'A gift is waiting for your effort!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                if (widget.isEdit) {
                  await FirebaseFirestore.instance
                      .collection('feedback')
                      .doc(widget.id)
                      .update({
                    'rating': _rating,
                    'comment': _commentController.text,
                  });
                  Navigator.pop(context);
                  showCustomDialog(context, 'assets/img_2.png',
                      'Thanks for Sharing your review?', '');
                } else {
                  if (_image == null) {
                    showCustomDialog(
                        context,
                        'assets/img_1.png',
                        'Please, upload or make a photo of work',
                        'If you have a photo, please upload it now. And we search you more interesting gift!');
                  } else if (_image != null &&
                      _commentController.text.isNotEmpty &&
                      _rating > 0) {
                    await uploadFeedback();

                    showCustomDialog(context, 'assets/img_2.png',
                        'Thanks for Sharing your review?', '');
                  } else {
                    showCustomDialog(
                        context,
                        'assets/img.png',
                        'Please, rate your satisfaction',
                        'We need it to give you a gift!');
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.blue),
                alignment: Alignment.center,
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
