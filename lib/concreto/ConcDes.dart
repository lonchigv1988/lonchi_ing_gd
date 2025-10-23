import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/concreto/VigDes.dart';
import 'package:lonchi_ing_gd/concreto/LosaDes.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyMenuButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';
import 'TrasGanch.dart';

class ConcDes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Conctype();
  }
}
class Conctype extends StatefulWidget {
@override
ConctypeState createState() {
  return ConctypeState();
}
}

class ConctypeState extends State<Conctype> {

  onButtonTap(Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
    // Navigator.push(
        // context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final MyProvider = Provider.of<DemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: MyAppBar('Diseño de concreto', context),
      // AppBar(
      //   title: Text("Diseño en acero"),
      //   centerTitle: true,
      //   backgroundColor: Colors.red,
      // ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            MyMenuButton(
              titulo: "Diseño de vigas",
              actionTap: () {
                onButtonTap(
                  VigDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Diseño de losas",
              actionTap: () {
                onButtonTap(
                  LosaDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Longitud de traslape y gancho",
              actionTap: () {
                onButtonTap(
                  TrasGanch(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}