import 'package:flutter/material.dart';
import '../tabs/micronutrients_tab.dart';

class MicronutrientsPage extends StatefulWidget {
  @override
  State<MicronutrientsPage> createState() => _MicronutrientsPageState();
}

class _MicronutrientsPageState extends State<MicronutrientsPage> {
  String _searchQuery = ''; // State to hold the search query
  bool _isSearchBarHidden =
      true; // State to track whether the search bar is hidden or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF422546),
          iconTheme: const IconThemeData(color: Colors.white),
          title: _isSearchBarHidden
              ? const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Micronutrients'),
                )
              : Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 1.0), // Add 2-pixel white border
                    borderRadius:
                        BorderRadius.circular(8), // Add rounded corners
                  ),
                  child: TextField(
                    style: const TextStyle(
                        color: Colors.white), // Set text color to white
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // Update the search query
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          color: Colors.white
                              .withOpacity(0.6)), // Set hint text color
// prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20,), // Set icon color
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .transparent), // Remove the line below the search bar
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .transparent), // Remove the line below the search bar
                      ),
                    ),
                  ),
                ),
          actions: [
            IconButton(
              splashRadius: 25,
              onPressed: () {
                setState(() {
                  _isSearchBarHidden =
                      !_isSearchBarHidden; // Toggle the search bar
                  _searchQuery = ''; // Clear the search query when toggling
                });
              },
              icon: Icon(_isSearchBarHidden ? Icons.search : Icons.clear),
            ),
          ],
        ),
        body: MicronutrientsTab(searchQuery: _searchQuery,));
  }
}
