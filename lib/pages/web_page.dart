import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../webview/navigation_controls.dart';
import '../webview/web_view_stack.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key, required this.linkUrl, required this.title}) : super(key: key);

  final String linkUrl; // Store the value of store1
  final String title;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.linkUrl), // Use the store1 parameter as the URL
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
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
