import 'dart:convert';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  final String contentJson;

  const CalculatorPage({
    Key? key,
    required this.contentJson,
  }) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controller = TextEditingController();
  double _inputValue = 1.0; // Default value
  List<Map<String, String>> _content = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateInputValue);
    _initializeContent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateInputValue() {
    setState(() {
      _inputValue = double.tryParse(_controller.text) ?? 1.0;
    });
  }

  void _initializeContent() {
    List<dynamic> jsonList = json.decode(widget.contentJson);
    _content = jsonList.map((dynamic map) => Map<String, String>.from(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF422546),
        elevation: 0,
        title: Text('Calculator Page'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF422546),
              child: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs:[
                  Tab(text: 'Scoops'),
                  Tab(text: 'Calories'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
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
                decoration: const InputDecoration(
                  labelText: 'Enter a value',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoopsTab() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _content.length,
      itemBuilder: (context, index) {
        Map<String, String> item = _content[index];
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(item["nutrition"]!),
                  const Spacer(),
                  Text(displayValue),
                ],
              ),
            ),
            if (index < _content.length - 1) const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildCaloriesTab() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _content.length,
      itemBuilder: (context, index) {
        Map<String, String> item = _content[index];
        double scoopsValue = double.tryParse(item["calorie"]!) ?? 0.0;
        double calculatedValue = scoopsValue * _inputValue;

        String displayValue;
        if (calculatedValue == calculatedValue.toInt()) {
          displayValue = calculatedValue.toInt().toString();
        } else {
          displayValue = calculatedValue.toStringAsFixed(2);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(item["nutrition"]!),
                  const Spacer(),
                  Text(displayValue),
                ],
              ),
            ),
            if (index < _content.length - 1) const Divider(),
          ],
        );
      },
    );
  }
}
