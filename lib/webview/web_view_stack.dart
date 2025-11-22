import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, Key? key})
      : super(key: key);

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  var isConnectedToInternet = true; // Initially assume there is internet.

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _checkInternetConnectivity(); // Check for internet connectivity on init.
  }

  Future<void> _checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnectedToInternet = !connectivityResult.contains(ConnectivityResult.none) && connectivityResult.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          if (isConnectedToInternet)
            WebViewWidget(
              controller: widget.controller,
            )
          else
            const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.signal_wifi_statusbar_connected_no_internet_4, size: 65,),
                  SizedBox(height: 15),
                  Text("No internet connection."),
                ],
              ),
            ),
          if (loadingPercentage < 100 && isConnectedToInternet)
            Container(
              color: Colors.white,
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
