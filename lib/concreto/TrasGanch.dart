import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyImage.dart';
import 'package:lonchi_ing_gd/MyWidgets/MySelectionButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputButton.dart';
import '../MyClasses/MyProviders.dart';


class TrasGanch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrasGanchScreen();
  }
}

class TrasGanchScreen extends StatefulWidget {
  State createState() =>  TrasGanchScreenState();
}

class TrasGanchScreenState extends State<TrasGanchScreen> {

  var e_e;
  double? epe;
  double? eps;
  var Barra = RebarCalc()[0];
  int? fc;
  int? fy;

  List Refuerzo = RebarCalc();
  List ListEpox = epoxList();

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SecProvider = Provider.of<VigProvider>(context, listen: false);
    fc = SecProvider.getfc();
    fy = SecProvider.getfy();
    if (SecProvider.getBsup1() == null){
      epe = 1.0;
      eps = 0.8;
    }
    // final MyProvider = Provider.of<DemProvider>(context, listen: false);
    // MyProvider.setTipo(0);
    // e_e = ListEpox[0];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Desarrollo, traslape y ganchos',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              SecProvider.setBsup1(null);
              SecProvider.setfc(210);
              SecProvider.setfy(4200);
              Navigator.pop(context, true);
            }),
      ),
      body: ListView(
          children: [
            MyTitle(titulo: 'RESISTENCIA:',),
            //INDICAR RESITENCIA CONCRETO
            MyInputButton(
              titulo: 'f´c (kg/cm2):',
              valinicial: SecProvider.getfc(),
              onSeleccionado: (number) {
                setState(() {
                  fc = int.parse(number.toString());
                  SecProvider.setfc(fc!);
                });
              },
            ),
            //INDICAR RESITENCIA ACERO LONGITUDINAL
            MyInputButton(
              titulo: 'fy (kg/cm2):',
              valinicial: SecProvider.getfy(),
              onSeleccionado: (number) {
                setState(() {
                  fy = int.parse(number.toString());
                  SecProvider.setfy(fy!);
                });
              },
            ),
            //INDICAR RESITENCIA ACERO CORTANTE
            MyTitle(titulo: 'REFUERZO:',),
            //BARRA SELECCIONADA
            MySelectionButton(
              titulo: 'Barra:',
              lista: Refuerzo,
              valor: (SecProvider.getBsup1() == null) ? null : SecProvider.getBsup1(),
              onSeleccionado: (rebar) {
                setState(() {
                  Barra = rebar;
                  SecProvider.setBsup1(Barra);
                  if (Barra.db <= 2) {
                    eps = 0.8;
                  }
                  else {
                    eps = 1.0;
                  }
                });
              },
            ),
            MySelectionButton(
              titulo: 'Recubrimiento:',
              lista: ListEpox,
              valor: ListEpox[0],
              onSeleccionado: (val) {
                setState(() {
                  e_e!.Name = val;
                  epe = e_e!.ee;
                });
              },
            ),
            //RESULTADOS
            // MyTitle(titulo: 'PROPIEDADES BARRA:',),
            MyResultButton(
              titulo: 'db =',
              result: '${Barra.db} cm',
            ),
            MyResultButton(
              titulo: 'Ab =',
              result: '${Barra.ab} cm2',
            ),
            MyTitle(titulo: 'LONG. DESARROLLO/TRASLAPE:',),
            MyResultButton(
              titulo: 'Ld-capa sup. =',
              result: '${(1.3*fy!*epe!*eps!*Barra.db/(5.3*sqrt(fc!))).round()} cm',
            ),
            MyResultButton(
              titulo: 'Ld-capa inf.=',
              result: '${(1.0*fy!*epe!*eps!*Barra.db/(5.3*sqrt(fc!))).round()} cm',
            ),
            MyResultButton(
              titulo: 'Sep =',
              result: '${(30*Barra.db).round()} cm',
            ),
            MyTitle(titulo: 'GANCHO ESTANDAR:',),
            MyResultButton(
              titulo: 'LP =',
              // result: '${(16*Barra.db).round()} cm',
              result: '${(0.075*fy!*epe!*Barra.db/sqrt(fc!)).round()} cm',
            ),
            MyResultButton(
              titulo: 'LG =',
              // result: '${(0.075*fy!*epe!*Barra.db/sqrt(fc!)).round()} cm',
              result: '${(16*Barra.db).round()} cm',
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(5.0),
            //     child: Container(
            //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10.0),
            //           color: Colors.grey[400],
            //           border: Border.all()),
            //       child: FlatButton(
            //         child: Text(
            //           "Provider",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 18,
            //           ),
            //         ),
            //         onPressed: (){
            //           print('eps ${eps}');
            //           print('epe ${epe}');
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            MyImage(
              imagen: 'assets/Gancho.png',
            ),
          ]),
    );
  }
}