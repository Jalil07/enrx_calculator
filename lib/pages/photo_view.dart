import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15),
        //     child: TextButton(onPressed: (){}, child: const Text('Request Order'),),
        //   ),
        // ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl), // Use CachedNetworkImageProvider
        ),
      ),
    );
  }
}
