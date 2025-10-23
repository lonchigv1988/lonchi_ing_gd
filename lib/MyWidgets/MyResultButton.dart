import 'package:flutter/material.dart';

class MyResultButton extends StatelessWidget {
  final String titulo;
  final result;

  MyResultButton({required this.titulo, required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 8,
          child: Text(titulo,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(result.toString(),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                )),
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