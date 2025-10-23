import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MySelectionButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyInputButton.dart';
import 'package:provider/provider.dart';
import '../MyWidgets/MyTitle.dart';
import 'MyProviders.dart';

class Deman {
  String? Name; double? MPi; double? MPc; double? MPd; double? MDi; double? MDc;
  double? MDd; double? VPi; double? VPc; double? VPd; double? VDi; double? VDc;
  double? VDd; double? DeP; double? DeD;

  Deman({this.Name, this.MPi, this.MPc, this.MPd, this.MDi, this.MDc,
    this.MDd, this.VPi, this.VPc, this.VPd, this.VDi, this.VDc, this.VDd,
    this.DeP, this.DeD});

  int get hashCode => Name.hashCode;

  bool operator==(Object other) => other is Deman && other.Name == Name;

  @override
  String toString() {
    return 'Deman: {Name: ${Name}}';
  }
}

DemCalc() {
  List Calc = [
    Deman(Name: 'Fix-Fix', MPi: -0.125, MPc: 0.125, MPd: -0.125, MDi: -0.0833333333333333, MDc: 0.0416666666666667, MDd: -0.0833333333333333, VPi: 0.5, VPc: 0, VPd: 0.5, VDi: 0.5, VDc: 0, VDd: 0.5, DeP: 0.00520833333333333, DeD: 0.00260416666666667),
    Deman(Name: 'Pin-Pin', MPi: 0, MPc: 0.25, MPd: 0, MDi: 0, MDc: 0.125, MDd: 0, VPi: 0.5, VPc: 0, VPd: 0.5, VDi: 0.5, VDc: 0, VDd: 0.5, DeP: 0.0208333333333333, DeD: 0.0130208333333333),
    Deman(Name: 'Voladizo', MPi: -1, MPc: -0.5, MPd: 0, MDi: -0.5, MDc: -0.125, MDd: 0, VPi: 1, VPc: 1, VPd: 1, VDi: 1, VDc: 0.5, VDd: 0, DeP: 0.333333333333333, DeD: 0.125),
    Deman(Name: 'Fix-pin', MPi: -0.1875, MPc: 0.15625, MPd: 0, MDi: -0.125, MDc: 0.0703125, MDd: 0, VPi: 0.6875, VPc: 0, VPd: 0.3125, VDi: 0.625, VDc: 0, VDd: 0.375, DeP: 0.00931694990624912, DeD: 0.00540540540540541),
  ];
  return Calc;
}



class Dem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DemScreen();
  }
}

class DemScreen extends StatefulWidget {

  State createState() =>  DemScreenState();
}

class DemScreenState extends State<DemScreen> {

  var DemandSelec;

  List<dynamic> Demand = DemCalc();

  int? i;
  var L;
  var Lb;
  var Ancho;
  var wCP;
  var wCT;
  var pCP;
  var pCT;
  var PesProp;
  var SecProvider;
  var MyProvider;
  var ResProvider;
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyProvider = Provider.of<DemProvider>(context);
    ResProvider = Provider.of<ResultProvider>(context);
    // final SecProvider = Provider.of<WProvider>(context, listen: false);
    i = MyProvider.getTipo();

    if (i == 0) {
      SecProvider = Provider.of<VigProvider>(context);
    }
    else if (i == 1){
      SecProvider = Provider.of<WProvider>(context);
    }

    var Apoyo = MyProvider.getApSel();


    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
        children: [
          //INDICAR LONGITUD DE ELEMENTO
          MyInputButton(
            titulo: 'Longitud (m):',
            valinicial: MyProvider.getLSel(),
            onSeleccionado: (number) {
              setState(() {
                L = double.parse(number.toString());
                MyProvider.setLSel(L);
                ResProvider.setL(L);
              });
            },
          ),
          //INDICAR LONGITUD ARRIOSTRADA DE ELEMENTO
          i == 1 ? MyInputButton(
            titulo: 'Long. Lb (m):',
            valinicial: SecProvider.getLbSel(),
            onSeleccionado: (number) {
              setState(() {
                Lb = double.parse(number.toString());
                SecProvider.setLbSel(Lb);
              });
            },
          ) : SizedBox(),
          //INDICAR APOYOS DE ELEMENTO PARA ESTIMACION DE DEMANDA
          MySelectionButton(
            titulo: 'Apoyos:',
            lista: Demand,
            valor: Apoyo,
            onSeleccionado: (Value1) {
              setState(() {
                MyProvider.setApSel(Value1);
                DemandSelec = Value1;
              });
            },
          ),
          MyTitle(titulo: 'CARGAS:',),
          //ANCHO TRIBUTARIO
          MyInputButton(
            titulo: 'Ancho trib. (m):',
            valinicial: MyProvider.getAncho(),
            onSeleccionado: (number) {
              setState(() {
                Ancho = double.parse(number.toString());
                MyProvider.setAncho(Ancho);
              });
            },
          ),
          //CARGAS SOBRE EL ELEMENTO
          MyInputButton(
            titulo: 'wCP (kg/m2):',
            valinicial: MyProvider.getwCPSel(),
            onSeleccionado: (number) {
              setState(() {
                wCP = double.parse(number.toString());
                MyProvider.setwCPSel(wCP);
              });
            },
          ),
          MyInputButton(
            titulo: 'wCT (kg/m2):',
            valinicial: MyProvider.getwCTSel(),
            onSeleccionado: (number) {
              setState(() {
                wCT= double.parse(number.toString());
                MyProvider.setwCTSel(wCT);
              });
            },
          ),
        ],
      ),
    );
  }
}