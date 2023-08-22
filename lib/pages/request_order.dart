// import 'package:flutter/material.dart';
// import 'web_page.dart'; // Import the StorePage
//
// class RequestOrderPage extends StatefulWidget {
//   String? store1;
//   String? store2;
//   String? store1Name;
//   String? store2Name;
//   final String imageUrl;
//
//   RequestOrderPage({
//     required this.imageUrl,
//     this.store1,
//     this.store2,
//     this.store1Name,
//     this.store2Name,
//   });
//
//   @override
//   State<RequestOrderPage> createState() => _RequestOrderPageState();
// }
//
// class _RequestOrderPageState extends State<RequestOrderPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF422546),
//         elevation: 0,
//         title: const Text('Request Order'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             itemBox(context, widget.store1, widget.store1Name,),
//             itemBox(context, widget.store2, widget.store2Name),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container itemBox(BuildContext context, String? store, String? storeName) {
//     if (store != null && store.isNotEmpty) {
//       return Container(
//         margin: const EdgeInsets.only(top: 25),
//         height: 250,
//         width: 250,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 1,
//               offset: const Offset(0, 2), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 25,
//             ),
//             Image.network(
//               widget.imageUrl,
//               height: 155,
//               width: 155,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(
//                   Icons.image_not_supported_outlined,
//                   color: Colors.white,
//                   size: 55,
//                 );
//               },
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StorePage(linkUrl: store!),
//                   ),
//                 );
//               },
//               child: Text(storeName!),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Return an empty container if store is null or empty
//       return Container();
//     }
//   }
// }
//
