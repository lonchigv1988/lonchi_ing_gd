import 'package:flutter/material.dart';
import "package:charcode/charcode.dart";
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:provider/provider.dart';
import 'MyProviders.dart';


class ResDef extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResDefScreen();
  }
}

class ResDefScreen extends StatefulWidget {

  State createState() =>  ResDefScreenState();
}

class ResDefScreenState extends State<ResDefScreen> {

  var L;
  var wCP;
  var wCT;
  var wCPP;
  var wCTT;
  var wCU;
  var Apoyo;
  var PP;
  var Ancho;
  var Ixx;
  var EE;

  int del = $dash;

  // var MDis;
  // var VDis;
  var Def;
  // double VMax;
  // double MMax;
  // double MMin;
  double? DefCP;
  double? DefCT;
  double? DefServ;

  // var pCP;
  // var pCT;
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    // L = MyProvider.getLSel();
    // wCP = MyProvider.getwCPSel();
    // wCT = MyProvider.getwCTSel();
    // Apoyo = MyProvider.getApSel();
    // Ancho = MyProvider.getAncho();
    // PP = MyProvider.getPesProp();
    // Ixx = MyProvider.getIxx();
    // EE = MyProvider.getEE();
    //
    // Def = Apoyo.DeD;
    //
    // wCPP = Ancho*wCP+PP;
    // wCTT = Ancho*wCT;
    //
    // DefCP = round((wCPP*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
    // DefCT = round((wCTT*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
    // DefServ = round(DefCP!+DefCT!,2);
    //
    // ResProvider.setDefCP(DefCP!);
    // ResProvider.setDefCT(DefCT!);
    // ResProvider.setDefServ(DefServ!);

    DefCP = ResProvider.getDefCP();
    DefCT = ResProvider.getDefCT();
    DefServ = ResProvider.getDefServ();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            MyResultButton(
              titulo: 'Defl. \u{0394}-CP =',
              result: '$DefCP mm',
            ),
            MyResultButton(
              titulo: 'Defl. \u{0394}-CT =',
              result: '$DefCT mm',
            ),
            MyResultButton(
              titulo: 'Defl. \u{0394}-Serv =',
              result: '$DefServ mm',
            ),
            // BOTON RESULTADOS
          //   Center(
          //   child: Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Container(
          //     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.grey[400],
          //         border: Border.all()),
          //     child: FlatButton(
          //       child: Text(
          //         "Provider",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 18,
          //         ),
          //       ),
          //       onPressed: (){
          //         print(EE);
          //         print(Ixx);
          //         // print(wCTT);
          //         // print (MMax);
          //         // print (VMax);
          //         // print (Apoyo.MDi);
          //         // print (AceroCalc()[18]);
          //         // print (MyProvider.getLSel());
          //         // print (MMax);
          //         // print (VMax);
          //         // print(AceroCalc().indexOf(Name.));
          //         // print('VMax $VMax');
          //         // print('Wtype $Wtype');
          //         // print('Provider WSelted ${wProvider.getSecSel()}');
          //         // print('WSelted $WSelted');
          //         // print('L = ${wProvider.getLSel()}');
          //         // print('Apoyos = ${wProvider.getApSel()}');
          //       },
          //     ),
          //   ),
          // ),
          // ),
            //SELECCIÓN DE FILTRO PARA ELEMENTOS W
          //   MySelectionButton(
          //     titulo: 'Filtro:',
          //     lista: Wsizes(),
          //     valor: (wProvider.getSecSizeSelec() == null) ? null : wProvider.getSecSizeSelec(),
          //     onSeleccionado: (Value1) {
          //       setState(() {
          //         wProvider.setSecSize(Value1);
          //         Wtype = Value1;
          //         Wfiltered = WProps.where(
          //                 (f) => f.Name.startsWith('${Wtype.Name}X'));
          //         Wselected = null;
          //         wProvider.setSecSelec(null);
          //         Aselected = 0;
          //         Aselectedcm = 0;
          //         Dselected = 0;
          //         Dselectedcm = 0;
          //         Bfselected = 0;
          //         Bfselectedcm = 0;
          //         tfselected = 0;
          //         tfselectedcm = 0;
          //         twselected = 0;
          //         twselectedcm = 0;
          //         Pesoselected = 0;
          //         Pesoselectedcm = 0;
          //       });
          //     },
          //   ),
          //   //SELECCIÓN DE SECCIÓN W
          //   MySelectionButton(
          //     titulo: 'Sección:',
          //     lista: Wfiltered,
          //     valor: (wProvider.getSecSelec() == null) ? null : wProvider.getSecSelec(),
          //     onSeleccionado: (Value2) {
          //       setState(() {
          //         wProvider.setSecSelec(Value2);
          //         Wselected = Value2;
          //         i = WProps.indexWhere(
          //                 (f) => f.Name == Wselected.Name);
          //         Aselected = Wselected.A;
          //         Aselectedcm = round(Aselected*2.54*2.54,1);
          //         Dselected = Wselected.d;
          //         Dselectedcm = round(Dselected*2.54,2);
          //         Bfselected = Wselected.bf;
          //         Bfselectedcm = round(Bfselected*2.54,2);
          //         tfselected = Wselected.tf;
          //         tfselectedcm = round(tfselected*2.54,2);
          //         twselected = Wselected.tw;
          //         twselectedcm = round(twselected*2.54,2);
          //         Pesoselected =Wselected.wt_ft;
          //         Pesoselectedcm =round(Pesoselected*1.488,0);
          //       });
          //     },
          //   ),
          //   //SELECCIÓN DE TIPO DE ACERO
          //   MySelectionButton(
          //     titulo: 'Tipo acero:',
          //     lista: AceroCalc(),
          //     valor: (wProvider.getAceroSelec() == null) ? null : wProvider.getAceroSelec(),
          //     onSeleccionado: (Value1) {
          //       setState(() {
          //         wProvider.setAceroSelec(Value1);
          //         if (wProvider.getAceroSelec() == null) {
          //           FySel = 0;
          //           FuSel = 0;
          //         }
          //         else {
          //           FySel = wProvider.getAceroSelec().Fy;
          //           FuSel = wProvider.getAceroSelec().Fu;
          //         }
          //         FySelcm = round(FySel*70,3);
          //         FuSelcm = round(FySel*70,3);
          //       });
          //     },
          //   ),
          //   //PROPIEDADES DE ELEMENTO SELECCIONADO
          //   MyResultButton(
          //     titulo: 'Fy =',
          //     result: '${FySel.round()} ksi // ${FySelcm.round()} kg/cm2',
          //   ),
          //   MyResultButton(
          //     titulo: 'Fu =',
          //     result: '${FuSel.round()} ksi // ${FuSelcm.round()} kg/cm2',
          //   ),
          //   MyResultButton(
          //     titulo: 'Área =',
          //     result: '$Aselected in2 // $Aselectedcm cm2',
          //   ),
          //   MyResultButton(
          //     titulo: 'Peralte =',
          //     result: '$Dselected in // $Dselectedcm cm',
          //   ),
          //   MyResultButton(
          //     titulo: 'Ancho =',
          //     result: '$Bfselected in // $Bfselectedcm cm',
          //   ),
          //   MyResultButton(
          //     titulo: 'tf =',
          //     result: '$tfselected in // $tfselectedcm cm',
          //   ),
          //   MyResultButton(
          //     titulo: 'tw =',
          //     result: '$twselected in // $twselectedcm cm',
          //   ),
          //   MyResultButton(
          //     titulo: 'Peso =',
          //     result: '${Pesoselected.round()} lb/ft // ${round(Pesoselectedcm,3).round()} kg/m',
          //   ),
          ]),
    );
  }
}