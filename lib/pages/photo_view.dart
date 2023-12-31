import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;

  ImagePreviewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15),
        //     child: TextButton(onPressed: (){}, child: const Text('Request Order'),),
        //   ),
        // ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl), // Use NetworkImage for external URLs
        ),
      ),
    );
  }
}
