import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator2Page extends StatefulWidget {
  final String contentJson;
  final String product;
  final String label;
  final String supplement;

  const Calculator2Page({
    Key? key,
    required this.contentJson,
    required this.product,
    required this.label,
    required this.supplement,
  }) : super(key: key);

  @override
  State<Calculator2Page> createState() => _Calculator2PageState();
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
    _content =
        jsonList.map((dynamic map) => Map<String, String>.from(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF422546),
        elevation: 0,
        title: FittedBox(fit: BoxFit.scaleDown, child: Text(widget.product, style: const TextStyle(color: Colors.white),)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.supplement,
                    style: const TextStyle(color: Colors.white)),
              ),
              const Spacer(),
              const Padding(
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
            child: _content.isEmpty
                ? Center(child: Text("Nothing to display for now"))
                : ListView.builder(
              shrinkWrap: true,
              itemCount: _content.length,
              itemBuilder: (context, index) {
                Map<String, String> item = _content[index];
                double scoopsValue =
                    double.tryParse(item["scoops"]!) ?? 0.0;
                if (scoopsValue == 0.0) {
                  return SizedBox.shrink(); // Skip entries with 0 value
                }
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
                        Clipboard.setData(ClipboardData(
                            text:
                            '${widget.product}: ${item["nutrition"]! } $displayValue'));
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
                    if (index < _content.length - 1)
                      const Divider(),
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
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
