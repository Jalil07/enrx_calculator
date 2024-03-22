import 'package:flutter/material.dart';
import '../tabs/ons_tab.dart';
import '../tabs/rehydration_tab.dart';

class TFFormulaPage extends StatefulWidget {
  const TFFormulaPage({super.key});

  @override
  State<TFFormulaPage> createState() => _TFFormulaPageState();
}

class _TFFormulaPageState extends State<TFFormulaPage> {
  final List<Tab> _tabs = [
    const Tab(text: 'ONS/TF Formulas'),
    const Tab(text: 'Rehydration Solution'),
  ];

  String _searchQuery = '';
  bool _isSearchBarHidden = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF422546),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: _tabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          title: _isSearchBarHidden
              ? Container() // Set text color to white
              : Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1.0), // Add 2-pixel white border
              borderRadius: BorderRadius.circular(8), // Add rounded corners
            ),
            child: TextField(
              style: const TextStyle(color: Colors.black), // Set text color to white
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update the search query
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey), // Set hint text color
                // suffix: Icon(Icons.clear, color: Colors.grey, size: 20,), // Set icon color
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Remove the line below the search bar
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Remove the line below the search bar
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 25,
              onPressed: () {
                setState(() {
                  _isSearchBarHidden = !_isSearchBarHidden; // Toggle the search bar
                  _searchQuery = ''; // Clear the search query when toggling
                });
              },
              icon: Icon(_isSearchBarHidden ? Icons.search : Icons.clear),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  ONSTab(searchQuery: _searchQuery), // Pass search query to tab
                  RehydrationTab(searchQuery: _searchQuery), // Pass search query to tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
