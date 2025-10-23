import 'package:flutter/material.dart';

PreferredSizeWidget? MyAppBar(String titulo, context) {
  return AppBar(
    title: Text(titulo,
      style: TextStyle(
        color: Colors.grey[400],
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.red[900],
    automaticallyImplyLeading: true,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios),
      color: Colors.grey[400],
      onPressed: () => Navigator.pop(context, true),
    ),
  );
}