import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator2Page extends StatefulWidget {
  final String contentJson;
  final String product;

  const Calculator2Page({
    Key? key,
    required this.contentJson, required this.product,
  }) : super(key: key);

  @override
  _Calculator2PageState createState() => _Calculator2PageState();
}

class _Calculator2PageState extends State<Calculator2Page> {
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
        title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(widget.product)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48), // Set the preferred height of the bottom row
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Supplements per cap/tab', style: TextStyle(color: Colors.white)),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Content', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: '${widget.product}: ${item["nutrition"]! } $displayValue'));
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
                    if (index < _content.length - 1) const Divider(),
                  ],
                );
              },
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
    );
  }

}
