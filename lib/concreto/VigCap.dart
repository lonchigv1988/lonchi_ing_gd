import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';



class VigCap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VigCapScreen();
  }
}

class VigCapScreen extends StatefulWidget {

  State createState() =>  VigCapScreenState();
}

class VigCapScreenState extends State<VigCapScreen> {

  double? as;
  double? ai;
  double? cs;
  double? ci;
  double? ds;
  double? di;
  double? db_s;
  double? db_i;
  double? db_a;
  double? h;
  double? b;
  double? rec;
  double? sep;
  double? fis;
  double? fii;
  double? fiv;
  int? fy;
  int? fyv;
  int? fc;
  double? B1;
  double? Ass;
  double? Asi;
  double? Asv;
  double? fMnp;
  double? fMnn;
  double? fVn;

  double? ecu;
  double? esy;
  double? esu;
  double? ess;
  double? esi;

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);
    final SecProvider = Provider.of<VigProvider>(context, listen: false);

    fMnp = ResProvider.getfMnpos();
    fMnn = ResProvider.getfMnneg();
    fVn = ResProvider.getfVnmax();

    h = SecProvider.getHVig();
    b = SecProvider.getBVig();
    rec = SecProvider.getrec();
    sep = SecProvider.getsep();
    db_s = SecProvider.getBsup1().db;
    db_i = SecProvider.getBinf1().db;
    db_a = SecProvider.getBaro().db;
    Ass = SecProvider.getAsup();
    Asi = SecProvider.getAinf();
    Asv = SecProvider.getAv();
    fc = SecProvider.getfc();
    fy = SecProvider.getfy();
    fyv = SecProvider.getfyv();

    if (fc! <= 280) {
      B1 = 0.85;
    }
    else if (fc! >= 580) {
      B1 = 0.65;
    }
    else {
      B1 = 0.85-0.05*(fc!-280)/70;
    }

    ecu = 0.003;
    esy = fy!/2030000.0;
    esu = 0.005;

    as = Ass!*fy! / (0.85*fc!*b!);
    cs = as! / B1!;
    ai = Asi!*fy! / (0.85*fc!*b!);
    ci = ai! / B1!;

    ds = h!-rec!-db_a!-db_s!/2.0;
    di = h!-rec!-db_a!-db_i!/2.0;

    ess = ecu!*(ds!-cs!)/cs!;
    if (ess! >= esu!) {
      fis = 0.90;
    }
    else if (ess! <= esy!) {
      fis = 0.65;
    }
    else {
      fis = 0.65+(0.9-0.65)*(ess!-esy!)/(esu!-esy!);
    }

    esi = ecu!*(di!-ci!)/ci!;
    if (esi! >= esu!) {
      fii = 0.90;
    }
    else if (esi! <= esy!) {
      fii = 0.65;
    }
    else {
      fii = 0.65+(0.9-0.65)*(esi!-esy!)/(esu!-esy!);
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            MyTitle(titulo: 'FLEXIÓN-MOMENTO POSITIVO:',),
            MyResultButton(
              titulo: '\u{03c6} =',
              result: '${round(fii,2)}',
            ),
            MyResultButton(
              titulo: '\u{03c6}Mn =',
              result: '$fMnp kg*m',
            ),
            MyTitle(titulo: 'FLEXIÓN-MOMENTO NEGATIVO:',),
            MyResultButton(
              titulo: '\u{03c6} =',
              result: '${round(fis,2)}',
            ),
            MyResultButton(
              titulo: '\u{03c6}Mn =',
              result: '$fMnn kg*m',
            ),
            MyTitle(titulo: 'CORTANTE:',),
            MyResultButton(
              titulo: '\u{03c6} =',
              result: '0.75',
            ),
            MyResultButton(
              titulo: '\u{03c6}Vn =',
              result: '$fVn kg',
            ),
          ]),
    );
  }
}