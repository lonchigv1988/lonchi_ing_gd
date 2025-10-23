import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';

class MyInputMalla extends StatelessWidget {
  final String titulo;
  void Function(Object?)? onSeleccionado1;
  void Function(Object?)? onSeleccionado2;
  final valinicial1;
  final valinicial2;
  final Iterable lista;

  MyInputMalla({required this.titulo, required this.onSeleccionado1, required this.onSeleccionado2,
    this.valinicial1, this.valinicial2, required this.lista});

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
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red[900],
                  border: Border.all()),
              child: DropdownButtonHideUnderline(
                child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.grey[800]),
                  child: DropdownButton(
                    hint: Text("Seleccionar"),
                    value: valinicial2,
                    onChanged: onSeleccionado2,
                    items: lista.map((list) {
                      return DropdownMenuItem(
                        value: list,
                        child: Row(
                          children: <Widget>[
                            // user.icon,
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              list.Name,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text('@',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red[900],
                  border: Border.all()),
              child: TextFormField(
                initialValue: (valinicial1 == null ? '0' : valinicial1),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                ),
                // controller: number,
                keyboardType: TextInputType.number,
                onChanged: onSeleccionado1,
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