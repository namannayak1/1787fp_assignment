import 'package:flutter/material.dart';

class TranscriptScreen extends StatelessWidget {
  final String transcript;

  TranscriptScreen({required this.transcript});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transcript', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Text(
              transcript,
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal[900],
                height: 1.6,  
                fontWeight: FontWeight.w400,  
              ),
            ),
          ),
        ),
      ),
    );
  }
}
