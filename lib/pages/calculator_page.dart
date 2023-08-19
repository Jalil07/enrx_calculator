import 'dart:convert';

import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  final String contentJson;

  CalculatorPage({
    required this.contentJson,
  });

  @override
  Widget build(BuildContext context) {
    // Convert the contentJson back to a List<Map<String, String>>
    List<Map<String, String>> content = [];
    List<String> listString = [
      // Your listString values
    ];

    // Convert contentJson back to List<Map<String, String>>
    List<dynamic> jsonList = json.decode(contentJson);
    for (var map in jsonList) {
      content.add(Map<String, String>.from(map));
    }

    // Now you have access to the content list in your CalculatorPage
    // You can use it to display the data in your UI

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator Page'),
      ),
      body: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) {
          // Build your UI using the content data
          // For example:
          Map<String, String> item = content[index];
          return ListTile(
            title: Text('Product: ${item["Product"]}'),
            subtitle: Text('Scoops: ${item["scoops"]}'),
            // Add more widgets as needed to display other data
          );
        },
      ),
    );
  }
}
