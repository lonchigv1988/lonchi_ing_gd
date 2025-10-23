import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputButton.dart';
import '../MyClasses/MyProviders.dart';


class VigDesEle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VigDesEleScreen();
  }
}

class VigDesEleScreen extends StatefulWidget {
  State createState() =>  VigDesEleScreenState();
}

class VigDesEleScreenState extends State<VigDesEleScreen> {

  int? i;
  double? H;
  double? B;
  double? rec;
  int? fc;
  int? fy;
  int? fyv;
  
  // WProp2 Wtype;
  // WProp WSel;
  // Deman DemandSel;
  // double ASel = 0;
  // double ASelcm = 0;
  // double DSel = 0;
  // double DSelcm = 0;
  // double BfSel = 0;
  // double BfSelcm = 0;
  // double tfSel = 0;
  // double tfSelcm = 0;
  // double twSel = 0;
  // double twSelcm = 0;
  // double PesoSel = 0;
  // double PesoSelcm = 0;
  // double FySel = 0;
  // double FySelcm = 0;
  // double FuSel = 0;
  // double FuSelcm = 0;
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
            MyInputButton(
              titulo: 'fyv (kg/cm2):',
              valinicial: SecProvider.getfyv().toString(),
              onSeleccionado: (number) {
                setState(() {
                  fyv = int.parse(number.toString());
                  SecProvider.setfy(fyv!);
                });
              },
            ),
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

            //SELCIÓN DE FILTRO PARA ELEMENTOS W
            // MySelectionButton(
            //   titulo: 'Filtro:',
            //   lista: Wsizes(),
            //   valor: (wProvider.getSecSizeSel() == null) ? null : wProvider.getSecSizeSel(),
            //   onSeleccionado: (Value1) {
            //     setState(() {
            //       wProvider.setSecSize(Value1);
            //       MyProvider.setTipo(1);
            //       Wtype = Value1;
            //       Wfiltered = WProps.where(
            //               (f) => f.Name.startsWith('${Wtype.Name}X'));
            //       WSel = null;
            //       wProvider.setSecSel(null);
            //       ASel = 0;
            //       ASelcm = 0;
            //       DSel = 0;
            //       DSelcm = 0;
            //       BfSel = 0;
            //       BfSelcm = 0;
            //       tfSel = 0;
            //       tfSelcm = 0;
            //       twSel = 0;
            //       twSelcm = 0;
            //       PesoSel = 0;
            //       PesoSelcm = 0;
            //       MyProvider.setPesProp(PesoSelcm);
            //       Ixx = 0;
            //       Ixxcm = 0;
            //       MyProvider.setIxx(Ixxcm);
            //     });
            //   },
            // ),
            // //SelCIÓN DE SECCIÓN W
            // MySelectionButton(
            //   titulo: 'Sección:',
            //   lista: Wfiltered,
            //   valor: (wProvider.getSecSel() == null) ? null : wProvider.getSecSel(),
            //   onSeleccionado: (Value2) {
            //     setState(() {
            //       wProvider.setSecSel(Value2);
            //       MyProvider.setTipo(1);
            //       WSel = Value2;
            //       i = WProps.indexWhere(
            //               (f) => f.Name == WSel.Name);
            //       ASel = WSel.A;
            //       ASelcm = round(ASel*2.54*2.54,1);
            //       DSel = WSel.d;
            //       DSelcm = round(DSel*2.54,2);
            //       BfSel = WSel.bf;
            //       BfSelcm = round(BfSel*2.54,2);
            //       tfSel = WSel.tf;
            //       tfSelcm = round(tfSel*2.54,2);
            //       twSel = WSel.tw;
            //       twSelcm = round(twSel*2.54,2);
            //       PesoSel =WSel.wt_ft;
            //       PesoSelcm =round(PesoSel*1.488,0);
            //       MyProvider.setPesProp(PesoSelcm);
            //       Ixx = WSel.Ix;
            //       Ixxcm = Ixx*pow(0.0254, 4);
            //       MyProvider.setIxx(Ixxcm);
            //     });
            //   },
            // ),
            // //SelCIÓN DE TIPO DE ACERO
            // MySelectionButton(
            //   titulo: 'Tipo acero:',
            //   lista: AceroCalc(),
            //   valor: (wProvider.getAceroSel() == null) ? null : wProvider.getAceroSel(),
            //   onSeleccionado: (Value1) {
            //     setState(() {
            //       wProvider.setAceroSel(Value1);
            //       if (wProvider.getAceroSel() == null) {
            //         FySel = 0;
            //         FuSel = 0;
            //       }
            //       else {
            //         FySel = wProvider.getAceroSel().Fy;
            //         FuSel = wProvider.getAceroSel().Fu;
            //       }
            //       FySelcm = round(FySel*70,3);
            //       FuSelcm = round(FySel*70,3);
            //     });
            //   },
            // ),
            //BOTÓN PARA PROVIDER
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
            //             "Calcular",
            //             style: TextStyle(
            //               color: WSelted != null && L != 0 && DemandSel != null ? Colors.black : Colors.grey,
            //               fontSize: 18,
            //             ),
            //           ),
            //           onPressed: onPressed),
            //     ),
            //   ),
            // ),
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
            //PROPIEDADES DE ELEMENTO SelCIONADO
            // MyResultButton(
            //   titulo: 'B =',
            //   result: '$B cm // $B cm',
            // ),
            // MyResultButton(
            //   titulo: 'H =',
            //   result: '$H cm // $H cm',
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