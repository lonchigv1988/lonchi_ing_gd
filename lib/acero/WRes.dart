import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';


class WRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WResScreen();
  }
}

class WResScreen extends StatefulWidget {

  State createState() =>  WResScreenState();
}

class WResScreenState extends State<WResScreen> {

  double? L;
  int? DefCP;
  int? DefCT;
  int? DefServ;
  double? Mpos;
  double? Mneg;
  double? Vmax;

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    L = ResProvider.getL();
    DefCP = (L!*1000/(ResProvider.getDefCP())).round();
    DefCT = (L!*1000/(ResProvider.getDefCT())).round();
    DefServ = (L!*1000/(ResProvider.getDefServ())).round();
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
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.teal,
            //           fixedSize: Size.fromWidth(100),
            //           padding: EdgeInsets.all(10),
            //         ),
            //         child: const Text(
            //           "Provider",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 18,
            //           ),
            //         ),
            //         onPressed: () {
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ]
      ),
    );
  }
}