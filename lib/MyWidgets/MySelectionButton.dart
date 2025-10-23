import 'package:flutter/material.dart';

class MySelectionButton extends StatelessWidget {
  final String titulo;
  final Iterable lista;
  final valor;
  void Function(Object?)? onSeleccionado;

  MySelectionButton({required this.titulo, required this.lista, required this.onSeleccionado, required this.valor});

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
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
              )),
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
              child: DropdownButtonHideUnderline(
                child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.grey[800]),
                  child: DropdownButton(
                    hint: Text("Seleccionar"),
                    value: valor,
                    onChanged: onSeleccionado,
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
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}