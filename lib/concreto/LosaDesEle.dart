import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputButton.dart';
import '../MyClasses/MyProviders.dart';


class LosaDesEle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LosaDesEleScreen();
  }
}

class LosaDesEleScreen extends StatefulWidget {
  State createState() =>  LosaDesEleScreenState();
}

class LosaDesEleScreenState extends State<LosaDesEleScreen> {

  int? i;
  double? H;
  double? B;
  double? rec;
  int? fc;
  int? fy;
  int? fyv;

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
    final SecProvider = Provider.of<LosaProvider>(context, listen: false);
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    MyProvider.setTipo(0);

    // B = SecProvider.getBVig();
    // H = SecProvider.getHVig();
    // fc = SecProvider.getfc();

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
            MyTitle(titulo: 'PROPIEDADES:',),
            //INDICAR RESITENCIA CONCRETO
            MyInputButton(
              titulo: 'f´c (kg/cm2):',
              valinicial: SecProvider.getfc().toString(),
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
              valinicial: SecProvider.getfy().toString(),
              onSeleccionado: (number) {
                setState(() {
                  fy = int.parse(number.toString());
                  SecProvider.setfy(fy!);
                });
              },
            ),
            //INDICAR RESITENCIA ACERO CORTANTE
            // MyInputButton(
            //   titulo: 'fyv (kg/cm2):',
            //   valinicial: SecProvider.getfyv().toString(),
            //   onSeleccionado: (number) {
            //     setState(() {
            //       fyv = int.parse(number.toString());
            //       SecProvider.setfy(fyv);
            //     });
            //   },
            // ),
            MyTitle(titulo: 'GEOMETRIA:',),
            //INDICAR ANCHO VIGA
            MyInputButton(
              titulo: 'Ancho (cm):',
              valinicial: SecProvider.getBVig(),
              onSeleccionado: (number) {
                setState(() {
                  B = double.parse(number.toString());
                  SecProvider.setBVig(B!);
                });
              },
            ),
            //INDICAR PERALTE VIGA
            MyInputButton(
              titulo: 'Altura (cm):',
              valinicial: SecProvider.getHVig(),
              onSeleccionado: (number) {
                setState(() {
                  H = double.parse(number.toString());
                  SecProvider.setHVig(H!);
                });
              },
            ),
            MyInputButton(
              titulo: 'Recubr. (cm):',
              valinicial: SecProvider.getrec().toString(),
              onSeleccionado: (number) {
                setState(() {
                  rec = double.parse(number.toString());
                  SecProvider.setHVig(rec!);
                });
              },
            ),
          ]),
    );
  }
}