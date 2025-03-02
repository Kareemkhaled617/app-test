import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For image upload
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  PickedFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? image =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _uploadDetails() async {
    String imageUrl = '';
    if (_image != null) {
      final File file = File(_image!.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().toIso8601String()}');
      final result = await ref.putFile(file);
      imageUrl = await result.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'businessName': _businessNameController.text,
      'fullName': _fullNameController.text,
      'mobileNumber': _mobileNumberController.text,
      'imageUrl': imageUrl, // Save the image URL from Firebase Storage
    });

    Navigator.of(context)
        .pop(); // Optionally navigate back or show a confirmation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Icon(Icons.camera_alt, color: Colors.grey[800])
                      : null,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(child: Text('Upload your logo/image')),
            SizedBox(height: 24),
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: 'Your Business Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Your Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('These details will not be published',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _uploadDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(36, 133, 230, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                ),
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
