import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  final String contentJson;
  final String product;

  const CalculatorPage({
    Key? key,
    required this.contentJson,
    required this.product,
  }) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  double _inputValue = 1.0; // Default value
  List<Map<String, String>> _content = [];
  TabController? _tabController; // Added TabController

  String _labelText = "Number of scoops/Sachet/Bottle"; // Initial label text

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateInputValue);
    _initializeContent();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_updateLabelText); // Added listener for tabs
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController!.dispose(); // Dispose of the TabController
    super.dispose();
  }

  void _updateInputValue() {
    setState(() {
      _inputValue = double.tryParse(_controller.text) ?? 1.0;
    });
  }

  void _initializeContent() {
    List<dynamic> jsonList = json.decode(widget.contentJson);
    _content =
        jsonList.map((dynamic map) => Map<String, String>.from(map)).toList();
  }

  void _updateLabelText() {
    if (_tabController!.index == 0) {
      setState(() {
        _labelText = "Number of scoops/Sachets/Bottles";
      });
    } else if (_tabController!.index == 1) {
      setState(() {
        _labelText = "Number of calories";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF422546),
        elevation: 0,
        title: FittedBox(fit: BoxFit.scaleDown, child: Text(widget.product)),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF422546),
            child: TabBar(
              controller: _tabController, // Added TabController
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Scoops'),
                Tab(text: 'Calories'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController, // Added TabController
              children: [
                // Tab 1: Scoops (ListView)
                _buildScoopsTab(),
                // Tab 2: Calories
                _buildCaloriesTab(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _labelText, // Use the dynamic label text
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoopsTab() {
    // Filter the content to exclude entries with scoops value of 0
    List<Map<String, String>> filteredContent =
    _content.where((item) => double.tryParse(item["scoops"]!) != 0).toList();

    if (filteredContent.isEmpty) {
      return const Center(child: Text("Nothing to display for now"));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredContent.length,
      itemBuilder: (context, index) {
        Map<String, String> item = filteredContent[index];
        double scoopsValue = double.tryParse(item["scoops"]!) ?? 0.0;
        double calculatedValue = scoopsValue * _inputValue;

        String displayValue;
        if (calculatedValue == calculatedValue.toInt()) {
          displayValue = calculatedValue.toInt().toString();
        } else {
          displayValue = calculatedValue.toStringAsFixed(2);
        }

        return Column(
          children: [
            InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: '${item["nutrition"]!} $displayValue'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(item["nutrition"]!),
                    const Spacer(),
                    Text(displayValue),
                  ],
                ),
              ),
            ),
            if (index < filteredContent.length - 1) const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildCaloriesTab() {
    // Filter the content to exclude entries with calorie value of 0
    List<Map<String, String>> filteredContent =
    _content.where((item) => double.tryParse(item["calorie"]!) != 0).toList();

    if (filteredContent.isEmpty) {
      return const Center(child: Text("Nothing to display for now"));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredContent.length,
      itemBuilder: (context, index) {
        Map<String, String> item = filteredContent[index];
        double caloriesValue = double.tryParse(item["calorie"]!) ?? 0.0;
        double calculatedValue = caloriesValue * _inputValue;

        String displayValue;
        if (calculatedValue == calculatedValue.toInt()) {
          displayValue = calculatedValue.toInt().toString();
        } else {
          displayValue = calculatedValue.toStringAsFixed(2);
        }

        return Column(
          children: [
            InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: '${widget.product}: ${item["nutrition"]!} $displayValue'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(item["nutrition"]!),
                    const Spacer(),
                    Text(displayValue),
                  ],
                ),
              ),
            ),
            if (index < filteredContent.length - 1) const Divider(),
          ],
        );
      },
    );
  }

}
