import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadBlogScreen extends StatefulWidget {
  @override
  _UploadBlogScreenState createState() => _UploadBlogScreenState();
}

class _UploadBlogScreenState extends State<UploadBlogScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);

    setState(() {
      _selectedImage = pickedImage;
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  Future<void> _uploadPost() async {
    if (_selectedImage != null) {
      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child(DateTime.now().toString() + ".jpg");
      await ref.putFile(File(_selectedImage!.path));

      // Get the download URL
      String imageUrl = await ref.getDownloadURL();

      // Upload post data to Realtime Database
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("Posts").push();
      await dbRef.set({
        'date': DateTime.now().toIso8601String(),
        'description': _descriptionController.text,
        'image': imageUrl,
        'time': TimeOfDay.now().format(context),
      });

      Navigator.pop(context); // Go back to the home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Upload Blog"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            InkWell(
              onTap: _showImageSourceDialog, // Change this line
              child: _selectedImage == null
                  ? Text(
                      'Upload an image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    )
                  : Image.file(File(_selectedImage!.path)),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Add a description...",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _uploadPost,
              child: Text("Add a new Blog"),
            ),
          ],
        ),
      ),
    );
  }
}
