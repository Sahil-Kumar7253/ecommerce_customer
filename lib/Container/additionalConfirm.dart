import 'package:flutter/material.dart';

class Additionalconfirm extends StatefulWidget {
  final String contentText;
  final VoidCallback onYes, onNo;

  const Additionalconfirm({
    super.key,
    required this.contentText,
    required this.onNo,
    required this.onYes,
  });

  @override
  State<Additionalconfirm> createState() => _AdditionalconfirmState();
}

class _AdditionalconfirmState extends State<Additionalconfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are You Sure"),
      content: Text(widget.contentText),
      actions: [
        TextButton(onPressed: widget.onNo, child: Text("No")),
        TextButton(onPressed: widget.onYes, child: Text("Yes")),
      ],
    );
  }
}
