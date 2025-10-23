import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputAros.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputRebar.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';


class VigDesRef extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VigDesRefScreen();
  }
}

class VigDesRefScreen extends StatefulWidget {
  State createState() =>  VigDesRefScreenState();
}

class VigDesRefScreenState extends State<VigDesRefScreen> {

  int? i;
  int? Nsup1;
  int? Nsup2;
  int? Ninf1;
  int? Ninf2;
  // Rebar? Bsup1;
  // Rebar? Bsup2;
  // Rebar? Binf1;
  // Rebar? Binf2;
  var Bsup1;
  var Bsup2;
  var Binf1;
  var Binf2;
  Rebar? Baro;
  double? H;
  double? B;
  double? sep;
  int? fc;
  int? fy;
  int? fyv;

  double? Asup1;
  double? Asup2;
  double? Asup;
  double? Ainf1;
  double? Ainf2;
  double? Ainf;
  double? Av;
  
  double Ixx = 0;
  double Ixxcm = 0;
  double EE = 29000.0*70.0*10000.0;

  List Refuerzo = RebarCalc();

  // List<dynamic> WProps = WPropList();
  // List<dynamic> Demand = DemCalc();
  // Iterable Wfiltered =[];

  // var L;
  // var Lb;
  // var wCP;
  // var wCT;
  // var pCP;
  // var pCT;
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SecProvider = Provider.of<VigProvider>(context, listen: false);
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    MyProvider.setTipo(0);

    Baro = SecProvider.getBaro();
    sep = SecProvider.getsep();
    Av = 2 * Baro!.ab;
    SecProvider.setAv(Av!);
    B = SecProvider.getBVig();
    H = SecProvider.getHVig();
    fc = SecProvider.getfc();
    fy = SecProvider.getfy();
    fyv = SecProvider.getfyv();
    sep = SecProvider.getsep();
    Nsup1 = SecProvider.getNsup1();
    Bsup1 = SecProvider.getBsup1();
    Nsup2 = SecProvider.getNsup2();
    Bsup2 = SecProvider.getBsup2();
    Ninf1 = SecProvider.getNinf1();
    Binf1 = SecProvider.getBinf1();
    Ninf2 = SecProvider.getNinf2();
    Binf2 = SecProvider.getBinf2();
    if (Bsup1 == null) {
      Asup1 = 0;
    }
    else {
      Asup1 = (Nsup1!*Bsup1!.ab) as double?;
    }
    if (Bsup2 == null) {
      Asup2 = 0;
    }
    else {
      Asup2 = (Nsup2!*Bsup2!.ab) as double?;
    }
    if (Binf1 == null) {
      Ainf1 = 0;
    }
    else {
      Ainf1 = (Ninf1!*Binf1!.ab) as double?;
    }
    if (Binf2 == null) {
      Ainf2 = 0;
    }
    else {
      Ainf2 = (Ninf2!*Binf2!.ab) as double?;
    }
    
    Asup = Asup1! + Asup2!;
    Ainf = Ainf1! + Ainf2!;
    
    // MyProvider.setEE(EE);
    // if (wProvider.getSecSizeSel() != null) {
    //   Wfiltered = WProps.where((f) => f.Name.startsWith('${wProvider.getSecSizeSel().Name}X'));}
    // if (wProvider.getSecSel() != null) {
    //   ASel = wProvider.getSecSel().A;
    //   ASelcm = round(ASel*2.54*2.54,1);
    //   DSel = wProvider.getSecSel().d;
    //   DSelcm = round(DSel*2.54,1);
    //   BfSel = wProvider.getSecSel().bf;
    //   BfSelcm = round(BfSel*2.54,1);
    //   tfSel = wProvider.getSecSel().tf;
    //   tfSelcm = round(tfSel*2.54,2);
    //   twSel = wProvider.getSecSel().tw;
    //   twSelcm = round(twSel*2.54,2);
    //   PesoSel = wProvider.getSecSel().wt_ft;
    //   PesoSelcm =round(PesoSel*1.488,1);
    //   MyProvider.setPesProp(PesoSelcm);
    //   Ixx = wProvider.getSecSel().Ix;
    //   Ixxcm = Ixx*pow(0.0254, 4);
    //   MyProvider.setIxx(Ixxcm);
    // }
    //
    // if (wProvider.getAceroSel() != null) {
    //   FySel = wProvider.getAceroSel().Fy;
    //   FySelcm = round(FySel * 70, 0);
    //   FuSel = wProvider.getAceroSel().Fu;
    //   FuSelcm = round(FuSel * 70, 0);
    // }
    // else {
    //   wProvider.setAceroSel(AceroCalc()[18]);
    //   FySel = wProvider.getAceroSel().Fy;
    //   FySelcm = round(FySel * 70, 0);
    //   FuSel = wProvider.getAceroSel().Fu;
    //   FuSelcm = round(FuSel * 70, 0);
    // }


    // var onPressed;
    // if (WSel != null && L != 0 && DemandSel != null) {
    //   onPressed = (){
    //     // print(L);
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (BuildContext context) => Wresults()));
    //   };
    // };

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            //INDICAR BARRAS DE REFUERZO
            MyTitle(titulo: 'REFUERZO SUPERIOR:',),
            MyInputRebar(
              titulo: 'Longitudinal:',
              valinicial1: SecProvider.getNsup1().toString(),
              onSeleccionado1: (number) {
                setState(() {
                  Nsup1 = int.parse(number.toString());
                  SecProvider.setNsup1(Nsup1!);
                  if (Bsup1 == null) {
                    Asup1 = 0;
                  }
                  else {
                    Asup1 = (Nsup1!*Bsup1!.ab) as double?;
                  }
                  SecProvider.setAsup(Asup1!+Asup2!);
                });
              },
              lista: Refuerzo,
              valinicial2: (SecProvider.getBsup1() == null) ? null : SecProvider.getBsup1(),
              onSeleccionado2: (rebar) {
                setState(() {
                  Bsup1 = rebar;
                  SecProvider.setBsup1(Bsup1);
                  if (Bsup1 == null) {
                    Asup1 = 0;
                  }
                  else {
                    Asup1 = (Nsup1!*Bsup1!.ab) as double?;
                  }
                  SecProvider.setAsup(Asup1!+Asup2!);
                });
              },
            ),
            MyInputRebar(
              titulo: 'Bastones:',
              valinicial1: SecProvider.getNsup2().toString(),
              onSeleccionado1: (number) {
                setState(() {
                  Nsup2 = int.parse(number.toString());
                  SecProvider.setNsup2(Nsup2!);
                  if (Bsup2 == null) {
                    Asup2 = 0;
                  }
                  else {
                    Asup2 = (Nsup2!*Bsup2!.ab) as double?;
                  }
                  SecProvider.setAsup(Asup1!+Asup2!);
                });
              },
              lista: Refuerzo,
              valinicial2: (SecProvider.getBsup2() == null) ? null : SecProvider.getBsup2(),
              onSeleccionado2: (rebar) {
                setState(() {
                  Bsup2 = rebar;
                  SecProvider.setBsup2(Bsup2);
                  if (Bsup2 == null) {
                    Asup2 = 0;
                  }
                  else {
                    Asup2 = (Nsup2!*Bsup2!.ab) as double?;
                  }
                  SecProvider.setAsup(Asup1!+Asup2!);
                });
              },
            ),
            MyResultButton(
              titulo: 'Asup =',
              result: '${Asup1!+Asup2!} cm2',
            ),
            MyTitle(titulo: 'REFUERZO INFERIOR:',),
            MyInputRebar(
              titulo: 'Longitudinal:',
              valinicial1: SecProvider.getNinf1().toString(),
              onSeleccionado1: (number) {
                setState(() {
                  Ninf1 = int.parse(number.toString());
                  SecProvider.setNinf1(Ninf1!);
                  if (Binf1 == null) {
                    Ainf1 = 0;
                  }
                  else {
                    Ainf1 = (Ninf1! * Binf1!.ab) as double?;
                  }
                  SecProvider.setAinf(Ainf1!+Ainf2!);
                });
              },
              lista: Refuerzo,
              valinicial2: (SecProvider.getBinf1() == null) ? null : SecProvider.getBinf1(),
              onSeleccionado2: (rebar) {
                setState(() {
                  Binf1 = rebar;
                  SecProvider.setBinf1(Binf1);
                  if (Binf1 == null) {
                    Ainf1 = 0;
                  }
                  else {
                    Ainf1 = (Ninf1! * Binf1!.ab) as double?;
                  }
                  SecProvider.setAinf(Ainf1!+Ainf2!);
                });
              },
            ),
            MyInputRebar(
              titulo: 'Bastones:',
              valinicial1: SecProvider.getNinf2().toString(),
              onSeleccionado1: (number) {
                setState(() {
                  Ninf2 = int.parse(number.toString());
                  SecProvider.setNinf2(Ninf2!);
                  if (Binf2 == null) {
                    Ainf2 = 0;
                  }
                  else {
                    Ainf2 = (Ninf2! * Binf2!.ab) as double?;
                  }
                  SecProvider.setAinf(Ainf1!+Ainf2!);
                });
              },
              lista: Refuerzo,
              valinicial2: (SecProvider.getBinf2() == null) ? null : SecProvider.getBinf2(),
              onSeleccionado2: (rebar) {
                setState(() {
                  Binf2 = rebar;
                  SecProvider.setBinf2(Binf2);
                  if (Binf2 == null) {
                    Ainf2 = 0;
                  }
                  else {
                    Ainf2 = (Ninf2! * Binf2!.ab) as double?;
                  }
                  SecProvider.setAinf(Ainf1!+Ainf2!);
                });
              },
            ),
            MyResultButton(
              titulo: 'Ainf =',
              result: '${Ainf1!+Ainf2!} cm2',
            ),
            MyTitle(titulo: 'REFUERZO CORTANTE:',),
            MyInputAros(
              titulo: 'Aros:',
              valinicial1: SecProvider.getsep().toString(),
              onSeleccionado1: (number) {
                setState(() {
                  sep = double.parse(number.toString());
                  SecProvider.setsep(sep!);
                  if (sep == null) {
                    Av = 0;
                  }
                  else {
                    Av = 2 * Baro!.ab;
                  }
                  SecProvider.setAv(Av!);
                });
              },
              lista: Refuerzo,
              valinicial2: (SecProvider.getBaro() == null) ? null : SecProvider.getBaro(),
              onSeleccionado2: (rebar) {
                setState(() {
                  Binf1 = rebar;
                  SecProvider.setBinf1(Binf1);
                  if (sep == null) {
                    Av = 0;
                  }
                  else {
                    Av = 2 * Baro!.ab;
                  }
                  SecProvider.setAv(Av!);
                });
              },
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
            //           child: Text(
            //             "Provider",
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 18,
            //             ),
            //           ),
            //           onPressed: (){
            //             print('Ref sup $Nsup1 ${SecProvider.getBsup1().Name}');
            //           },
            //       ),
            //     ),
            //   ),
            // ),
            // MyResultButton(
            //   titulo: 'Fu =',
            //   result: '${FuSel.round()} ksi // ${FuSelcm.round()} kg/cm2',
            // ),
            // MyResultButton(
            //   titulo: 'Área =',
            //   result: '$ASel in2 // $ASelcm cm2',
            // ),
            // MyResultButton(
            //   titulo: 'Peralte =',
            //   result: '$DSel in // $DSelcm cm',
            // ),
            // MyResultButton(
            //   titulo: 'Ancho =',
            //   result: '$BfSel in // $BfSelcm cm',
            // ),
            // MyResultButton(
            //   titulo: 'tf =',
            //   result: '$tfSel in // $tfSelcm cm',
            // ),
            // MyResultButton(
            //   titulo: 'tw =',
            //   result: '$twSel in // $twSelcm cm',
            // ),
            // MyResultButton(
            //   titulo: 'Peso =',
            //   result: '${PesoSel.round()} lb/ft // ${round(PesoSelcm,3).round()} kg/m',
            // ),
          ]),
    );
  }
}