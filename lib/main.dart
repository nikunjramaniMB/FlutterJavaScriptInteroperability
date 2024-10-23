import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

// Declares external JavaScript function
@JS('fetchDataFromAPI')
external dynamic fetchDataFromAPI(String url);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JS Interop Complex Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> _fetchData() async {
    // Call the JavaScript function and wait for the promise to complete
    final result = await promiseToFuture(fetchDataFromAPI("https://jsonplaceholder.typicode.com/todos/1")); // Example API

    // Convert the JSON string result into a Dart Map
    return jsonDecode(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter JS Interop"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fetched Data:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
