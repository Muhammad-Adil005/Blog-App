import 'package:blog_app/screens/upload_blog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Login.dart';
import 'auth/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _postsRef =
      FirebaseDatabase.instance.ref().child("Posts");

  List<Map<dynamic, dynamic>> _listOfPosts = [];

  void _fetchPosts() {
    _postsRef.onChildAdded.listen((DatabaseEvent event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> value = dataSnapshot.value as Map;
      _listOfPosts.add(value);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthenticationHelper().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadBlogScreen()));
        },
        child: Icon(Icons.camera_alt),
      ),
      body: _listOfPosts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listOfPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 250.h,
                  child: Card(
                    clipBehavior: Clip
                        .antiAlias, // This will ensure the image does not go out of the card's rounded corners
                    child: Stack(
                      children: [
                        // Image
                        Image.network(
                          _listOfPosts[index]['image'],
                          fit: BoxFit
                              .cover, // This will fill the card with the image
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Date (Top Left)
                        Positioned(
                          top: 10.0,
                          left: 10.0,
                          child: Text(
                            _listOfPosts[index]['date'],
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.black.withOpacity(
                                  0.7), // Semi-transparent background for visibility
                            ),
                          ),
                        ),
                        // Time (Top Right)
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: Text(
                            _listOfPosts[index]['time'],
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.black.withOpacity(
                                  0.7), // Semi-transparent background for visibility
                            ),
                          ),
                        ),
                        // Description (Bottom Center)
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 10.0,
                          child: Container(
                            color: Colors.black.withOpacity(
                                0.7), // Semi-transparent background for visibility
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              _listOfPosts[index]['description'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
