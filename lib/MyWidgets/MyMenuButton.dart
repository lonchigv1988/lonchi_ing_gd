import 'package:flutter/material.dart';

class MyMenuButton extends StatelessWidget {
  final String titulo;
  final VoidCallback actionTap;

  MyMenuButton({required this.titulo, required this.actionTap});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3,0,3,3),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red[900],
          minimumSize: Size(2.0, 40.0),
        ),
        onPressed: actionTap,
        child: new Text(
          titulo,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}