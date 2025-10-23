import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';

class MyInputButton extends StatelessWidget {
  final String titulo;
  void Function(Object?)? onSeleccionado;
  final valinicial;

  MyInputButton({required this.titulo, required this.onSeleccionado, required this.valinicial});

  @override
  Widget build(BuildContext context) {
    final wProvider = Provider.of<WProvider>(context, listen: false);
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 8,
          child: Text(titulo,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red[900],
                  border: Border.all()),
              child: TextFormField(
                initialValue: (valinicial == null ? '0' : valinicial.toString()),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                ),
                // controller: number,
                keyboardType: TextInputType.number,
                onChanged: onSeleccionado,
              ),
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