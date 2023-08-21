import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../webview/navigation_controls.dart';
import '../webview/web_view_stack.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key, required this.store1}) : super(key: key);

  final String store1; // Store the value of store1

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.store1), // Use the store1 parameter as the URL
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Request Order',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(controller: controller),
    );
  }
}
