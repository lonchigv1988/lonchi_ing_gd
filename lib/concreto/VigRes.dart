import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';

class VigRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VigResScreen();
  }
}

class VigResScreen extends StatefulWidget {

  State createState() =>  VigResScreenState();
}

class VigResScreenState extends State<VigResScreen> {

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
    print(ResProvider.getDefCP());
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
    // Mpos = ResProvider.getMpos();
    // Mneg = ResProvider.getMneg();
    // Vmax = ResProvider.getVmax();


    // MDis = [Apoyo.MDi, Apoyo.MDc, Apoyo.MDd];
    // VDis = [Apoyo.VDi, Apoyo.VDc, Apoyo.VDd];
    // Def = Apoyo.DeD;
    //
    // wCPP = Ancho*wCP+PP;
    // wCTT = Ancho*wCT;
    // // wCU = MaxVal([1.4*wCPP, 1.2*wCPP+1.6*wCTT]);
    //
    // // MMax = round(MaxVal([MaxVal(MDis),0])*wCU*L*L,2);
    // // MMin = round(MinVal([MinVal(MDis),0])*wCU*L*L,2);
    // // VMax = round(MaxVal([MaxVal(VDis), MinVal(VDis)*-1])*wCU*L,2);
    // DefCP = round((wCPP*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
    // DefCT = round((wCTT*pow(L,4)*Def/(EE*Ixx))*1000.0,2);

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
          ]),
    );
  }
}