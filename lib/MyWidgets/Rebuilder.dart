import 'package:flutter/material.dart';
import 'dart:async';

class Rebuilder extends StatefulWidget {
  const Rebuilder({ super.key });

  @override
  State<Rebuilder> createState() => _RebuilderState();

}

class _RebuilderState extends State<Rebuilder> {

  @override
  void initState() {
    Timer(Duration(milliseconds: 400), () {
      Navigator.pop(context, true);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              "Cargando",
              style: TextStyle(color: Colors.red[900]),
              textAlign: TextAlign.center,
            ),
          ),
        )
    );
  }
}