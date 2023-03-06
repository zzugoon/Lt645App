import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/destination.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: 'Sample Text');
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title} MyInfoPage - /list/text'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[50],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(
          controller: textController,
          style: theme.primaryTextTheme.headlineMedium?.copyWith(
            color: widget.destination.color,
          ),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.destination.color,
                width: 3.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}