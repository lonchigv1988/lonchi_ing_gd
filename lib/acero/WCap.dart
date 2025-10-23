import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';


class WCap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WCapScreen();
  }
}

class WCapScreen extends StatefulWidget {

  State createState() =>  WCapScreenState();
}

class WCapScreenState extends State<WCapScreen> {

  var b_2tf;
  var h_tw;
  var Lam_pf;
  var Lam_rf;
  var Lam_rfa;
  var f_comf;
  var f_coma;
  var Lam_pw;
  var Lam_rw;
  var Lam_rwa;
  var w_comf;
  var w_coma;
  var Fy;
  var Fu;

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

  var Mn;
  var Mn1;
  var Mn2;
  var Mn3;

  // var MDis;
  // var VDis;
  var Def;
  // double VMax;
  // double MMax;
  // double MMin;
  late double DefCP;
  late double DefCT;
  late double DefServ;

  // var pCP;
  // var pCT;
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SecProvider = Provider.of<WProvider>(context, listen: false);
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    Fy = SecProvider.getAceroSel().Fy;
    Fu = SecProvider.getAceroSel().Fu;

    //REVISION DE COMPACTA EN FLEXION
    b_2tf = SecProvider.getSecSel().bf_2tf;
    Lam_pf = 0.38*sqrt(29000/Fy);
    Lam_rf = 1.0*sqrt(29000/Fy);
    if (b_2tf <= Lam_pf) {
      f_comf = 1;
    }
    else if (b_2tf > Lam_rf) {
      f_comf = 3;
    }
    else {f_comf = 2;}

    h_tw = SecProvider.getSecSel().h_tw;
    Lam_pw = 3.76*sqrt(29000/Fy);
    Lam_rw = 5.70*sqrt(29000/Fy);
    if (h_tw <= Lam_pw) {
      w_comf = 1;
    }
    else if (h_tw > Lam_rw) {
      w_comf = 3;
    }
    else {w_comf = 2;}

    //REVISION DE COMPACTA EN AXIAL
    Lam_rfa = 0.56*sqrt(29000/Fy);
    if (b_2tf <= Lam_rfa) {
      f_coma = 1;
    }
    else {f_coma = 2;}

    Lam_rwa = 1.49*sqrt(29000/Fy);
    if (h_tw <= Lam_rwa) {
      w_coma = 1;
    }
    else {w_coma = 2;}



    //REVISION POR FLEXION
    //FLEXION-FLUENCIA
    Mn1 = Fy*SecProvider.getSecSel().Zx;

    //PANDEO LATERAL TOSIONAL-FLEXION

    L = MyProvider.getLSel();
    wCP = MyProvider.getwCPSel();
    wCT = MyProvider.getwCTSel();
    Apoyo = MyProvider.getApSel();
    Ancho = MyProvider.getAncho();
    PP = MyProvider.getPesProp();
    Ixx = MyProvider.getIxx();
    EE = MyProvider.getEE();

    // MDis = [Apoyo.MDi, Apoyo.MDc, Apoyo.MDd];
    // VDis = [Apoyo.VDi, Apoyo.VDc, Apoyo.VDd];
    Def = Apoyo.DeD;

    wCPP = Ancho*wCP+PP;
    wCTT = Ancho*wCT;
    // wCU = MaxVal([1.4*wCPP, 1.2*wCPP+1.6*wCTT]);

    // MMax = round(MaxVal([MaxVal(MDis),0])*wCU*L*L,2);
    // MMin = round(MinVal([MinVal(MDis),0])*wCU*L*L,2);
    // VMax = round(MaxVal([MaxVal(VDis), MinVal(VDis)*-1])*wCU*L,2);
    DefCP = round((wCPP*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
    DefCT = round((wCTT*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
    DefServ = round(DefCP+DefCT,2);
    
    ResProvider.setDefCP(DefCP);
    ResProvider.setDefCT(DefCT);
    ResProvider.setDefServ(DefServ);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            MyResultButton(
              titulo: 'Defl CP =',
              result: '$DefCP mm',
            ),
            MyResultButton(
              titulo: 'Defl CT =',
              result: '$DefCT mm',
            ),
            MyResultButton(
              titulo: 'Defl Serv =',
              result: '$DefServ mm',
            ),
            // BOTON RESULTADOS
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[400],
                      border: Border.all()),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      fixedSize: Size.fromWidth(100),
                      padding: EdgeInsets.all(10),
                    ),
                    child: const Text(
                      "Provider",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      print(EE);
                      print(Ixx);
                    },
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}