import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  final String? title;

  FullScreenImagePage({required this.imageUrl,this.title});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(
          this.title ?? "",
          style: TextStyle(color: Colors.white.withOpacity(.5)),
          // Change title color here
        ),
        backgroundColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the screen
              },
              child:  Icon(
                Icons.close,
                color: Colors.white.withOpacity(.5),
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover, // To make the image cover the entire screen
        ),
      ),
      backgroundColor: Colors.black, // Set background color to black
    );
  }
}

class FullScreenImagePage1 extends StatefulWidget {
  final String imageUrl;
  final String? title;

  FullScreenImagePage1({required this.imageUrl, this.title});

  @override
  _FullScreenImagePage1State createState() => _FullScreenImagePage1State();
}

class _FullScreenImagePage1State extends State<FullScreenImagePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Image.network(
          widget.imageUrl, // Use widget.imageUrl instead of hardcoded string
          fit: BoxFit.cover, // To make the image cover the entire screen
        ),
      ),
      backgroundColor: Colors.black, // Set background color to black
    );
  }
}