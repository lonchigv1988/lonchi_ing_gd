import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String titulo;

  MyTitle({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 10,
          child: Text(titulo,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 18,

            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}