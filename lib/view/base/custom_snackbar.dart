import 'package:flutter/material.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Theme.of(context).primaryColor : Colors.green,duration: Duration(milliseconds: 1000),
    content: Text(message),
  ));
}