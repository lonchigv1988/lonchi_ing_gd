import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import 'package:provider/provider.dart';

import '../MyClasses/MyProviders.dart';

class LosaRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LosaResScreen();
  }
}

class LosaResScreen extends StatefulWidget {

  State createState() =>  LosaResScreenState();
}

class LosaResScreenState extends State<LosaResScreen> {

  double? L;
  int? DefCP;
  int? DefCT;
  int? DefServ;
  double? Mupos;
  double? Muneg;
  double? Vumax;
  double? fMnpos;
  double? fMnneg;
  double? fVnmax;

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    L = ResProvider.getL();
    if (ResProvider.getDefCP() > 0){
      DefCP = (L!*1000/(ResProvider.getDefCP())).round();
    }
    else {
      DefCP = 99999;
    }

    if (ResProvider.getDefCT() > 0){
      DefCT = (L!*1000/(ResProvider.getDefCT())).round();
    }
    else {
      DefCT = 99999;
    }

    if (ResProvider.getDefServ() > 0){
      DefServ = (L!*1000/(ResProvider.getDefServ())).round();
    }
    else {
      DefServ = 99999;
    }
    Mupos = ResProvider.getMupos();
    Muneg = ResProvider.getMuneg();
    Vumax = ResProvider.getVumax();
    fMnpos = ResProvider.getfMnpos();
    fMnneg = ResProvider.getfMnneg();
    fVnmax = ResProvider.getfVnmax();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            MyTitle(titulo: 'FLEXION - MOMENTO POSITIVO:',),
            MyResultButton(
              titulo: 'Mu / \u{03c6}Mn =',
              result: '${Abs(round(Mupos!/fMnpos!,2))}',
            ),
            MyTitle(titulo: 'FLEXION - MOMENTO NEGATIVO:',),
            MyResultButton(
              titulo: 'Mu / \u{03c6}Mn =',
              result: '${Abs(round(Muneg!/fMnneg!,2))}',
            ),
            MyTitle(titulo: 'CORTANTE:',),
            MyResultButton(
              titulo: 'Vu / \u{03c6}Vn =',
              result: '${Abs(round(Vumax!/fVnmax!,2))}',
            ),
            MyTitle(titulo: 'DEFLEXIONES:',),
            MyResultButton(
              titulo: 'Defl CP =',
              result: 'L / $DefCP',
            ),
            MyResultButton(
              titulo: 'Defl CT =',
              result: 'L / $DefCT',
            ),
            MyResultButton(
              titulo: 'Defl Serv =',
              result: 'L / $DefServ',
            ),
            // MyResultButton(
            //   titulo: 'V max =',
            //   result: '$VMax kg',
            // ),
            // BOTON RESULTADOS
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
            //           // print(EE);
            //           // print(Ixx);
            //           // print(wCTT);
            //           // print (MMax);
            //           // print (VMax);
            //           // print (Apoyo.MDi);
            //           // print (AceroCalc()[18]);
            //           // print (MyProvider.getLSel());
            //           // print (MMax);
            //           // print (VMax);
            //           // print(AceroCalc().indexOf(Name.));
            //           // print('VMax $VMax');
            //           // print('Wtype $Wtype');
            //           // print('Provider WSelted ${wProvider.getSecSel()}');
            //           // print('WSelted $WSelted');
            //           // print('L = ${wProvider.getLSel()}');
            //           // print('Apoyos = ${wProvider.getApSel()}');
            //         },
            //       ),
            //     ),
            //   ),
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