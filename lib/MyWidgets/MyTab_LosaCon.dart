import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import '../MyClasses/MyProviders.dart';


class MyTab_LosaCon extends StatelessWidget {
  final String titulo;
  final listatab;
  final Widget loc;
  // var SeccSelec;
  // var LongSelec;
  // var ApoyoSelec;


  MyTab_LosaCon({required this.titulo, required this.listatab, required this.loc});

  // MyTab_LosaCon({this.titulo, this.listatab, this.loc,
  //   this.SeccSelec, this.LongSelec,this.ApoyoSelec});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final SecProvider = Provider.of<LosaProvider>(context, listen: false);
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    var onPressed;
    var numtabs = listatab.length;
    var ListTab = <Widget>[];
    var ListFunc = <Widget>[];

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
    var MDis;
    var VDis;
    var Def;
    double? DefCP;
    double? DefCT;
    double? DefServ;
    double? VuMax;
    double? MuMax;
    double? MuMin;

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

    listatab.forEach((i){
      var e = new Tab(icon: i.tabicon, text:i.txt);
      ListTab.add(e);
      return ListTab;
    });

    listatab.forEach((i){
      ListFunc.add(i.func);
      return ListFunc;
    });

    return DefaultTabController(
      length: numtabs,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar:
        // MyAppBar('Resultados', context),
        AppBar(
          title: Text(titulo,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[900],
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
                    MyProvider.setLSel(null);
                    MyProvider.setAncho(null);
                    MyProvider.setwCPSel(0);
                    MyProvider.setwCTSel(0);
                    MyProvider.setApSel(null);
                    SecProvider.setHVig(null);
                    SecProvider.setBVig(100);
                    SecProvider.setrec(3);
                    SecProvider.setfc(210);
                    SecProvider.setfy(4200);
                    SecProvider.setfyv(2800);
                    // SecProvider.setBsup1(RebarCalc()[1]);
                    // SecProvider.setBinf1(RebarCalc()[1]);
                    SecProvider.setBsup1(null);
                    SecProvider.setBinf1(null);
                    SecProvider.setBsup2(RebarCalc()[0]);
                    SecProvider.setBinf2(RebarCalc()[0]);
                    SecProvider.setBaro(RebarCalc()[2]);
                    SecProvider.setsep(15);
                    SecProvider.setNsup1(20);
                    SecProvider.setNsup2(20);
                    SecProvider.setNinf1(20);
                    SecProvider.setNinf2(20);
                    ResProvider.setL(0);
                    Navigator.pop(context, true);
                  }),
          bottom: TabBar(
            isScrollable: false,
            tabs: ListTab,
          ),
        ),
        body: TabBarView(
          children: ListFunc,
        ),
        bottomNavigationBar: Consumer2<LosaProvider, DemProvider>(
            builder: (context, SecProvider, MyProvider, child) {
          return BottomAppBar(
            color: Colors.red[900],
            child: IconButton(
              icon: Icon(Icons.calculate),
              color: SecProvider.getHVig() != null &&
                  SecProvider.getHVig() != 0.0 &&
                  SecProvider.getBVig() != null &&
                  SecProvider.getBVig() != 0.0 &&
                  SecProvider.getfc() != 0.0 &&
                  SecProvider.getfy() != 0.0 &&
                  SecProvider.getNsup1() != 0 &&
                  SecProvider.getBsup1() != null &&
                  SecProvider.getNinf1() != 0 &&
                  SecProvider.getBinf1() != null &&
                  MyProvider.getLSel() != 0.0 &&
                  MyProvider.getLSel() != null &&
                  MyProvider.getApSel() != null
                  ? Colors.black
                  : Colors.grey[600],
                iconSize: 45,
            onPressed: () {
              if (SecProvider.getHVig() != null &&
                  SecProvider.getHVig() != 0.0 &&
                  SecProvider.getBVig() != null &&
                  SecProvider.getBVig() != 0.0 &&
                  SecProvider.getfc() != 0.0 &&
                  SecProvider.getfy() != 0.0 &&
                  SecProvider.getNsup1() != 0 &&
                  SecProvider.getBsup1() != null &&
                  SecProvider.getNinf1() != 0 &&
                  SecProvider.getBinf1() != null &&
                  MyProvider.getLSel() != 0.0 &&
                  MyProvider.getLSel() != null &&
                  MyProvider.getApSel() != null) {
                MyProvider.setIxx(
                    SecProvider.getBVig()*pow(SecProvider.getHVig(),3)/12/100000000
                );
                MyProvider.setEE(
                    15100*sqrt(SecProvider.getfc())*10000*.75
                );
                MyProvider.setPesProp(
                    2400*SecProvider.getHVig()*SecProvider.getBVig()/10000
                );
                //OBTENER PROPIEDADES GENERALES
                  L = MyProvider.getLSel();
                  wCP = MyProvider.getwCPSel();
                  wCT = MyProvider.getwCTSel();
                  Ancho = MyProvider.getAncho();
                  PP = MyProvider.getPesProp();

                  Apoyo = MyProvider.getApSel();
                  MDis = [Apoyo.MDi, Apoyo.MDc, Apoyo.MDd];
                  VDis = [Apoyo.VDi, Apoyo.VDc, Apoyo.VDd];
                  Def = Apoyo.DeD;

                  h = SecProvider.getHVig();
                  b = SecProvider.getBVig();
                  rec = SecProvider.getrec();

                  Ixx = MyProvider.getIxx();
                  EE = MyProvider.getEE();

                  wCPP = Ancho*wCP+PP;
                  wCTT = Ancho*wCT;
                  print(wCTT);
                //CALCULO DE DEMANDAS
                  wCU = MaxVal([1.4*wCPP, 1.2*wCPP+1.6*wCTT]);

                  MuMax = round(MaxVal([MaxVal(MDis),0])*wCU*L*L,0);
                  MuMin = round(MinVal([MinVal(MDis),0])*wCU*L*L,0);
                  VuMax = round(MaxVal([MaxVal(VDis), MinVal(VDis)*-1])*wCU*L,0);

                  ResProvider.setMupos(MuMax!);
                  ResProvider.setMuneg(MuMin!);
                  ResProvider.setVumax(VuMax!);

                //CALCULO DE DEMANDAS
                  sep = SecProvider.getsep();
                  db_s = SecProvider.getBsup1().db;
                  db_i = SecProvider.getBinf1().db;
                  Ass = SecProvider.getAsup();
                  Asi = SecProvider.getAinf();
                  fc = SecProvider.getfc();
                  fy = SecProvider.getfy();

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

                  ds = h!-rec!-db_s!/2.0;
                  di = h!-rec!-db_i!/2.0;

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

                  fMnn = fis!*(Ass!*2800)*(ds!-as!/2)/100; //fis*(Ass*fy)*(ds-as/2)/100;
                  fMnn = round(fMnn, 0);
                  fMnp = fii!*(Asi!*2800)*(di!-ai!/2)/100; //fii*(Asi*fy)*(di-ai/2)/100;
                  fMnp = round(fMnp, 0);
                  fVn =round(0.75*(0.53*sqrt(fc!)*b!*MinVal([ds,di])),0);

                  ResProvider.setfMnpos(fMnp!);
                  ResProvider.setfMnneg(fMnn!);
                  ResProvider.setfVnmax(fVn!);

                //CALCULO DE DEFLEXIONES
                  DefCP = round((wCPP*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
                  DefCT = round((wCTT*pow(L,4)*Def/(EE*Ixx))*1000.0,2);
                  DefServ = round(DefCP!+DefCT!,2);

                  ResProvider.setDefCP(DefCP!);
                  ResProvider.setDefCT(DefCT!);
                  ResProvider.setDefServ(DefServ!);

                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => loc));
              }
              else {ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                    (SecProvider.getHVig() == null || SecProvider.getHVig() == 0.0) ? Text('Falta definir espesor de losa'):
                    (SecProvider.getBVig() == null || SecProvider.getBVig() == 0.0) ? Text('Falta definir ancho de losa'):
                    (SecProvider.getfc() == 0.0 || SecProvider.getfy() == 0.0) ? Text('Falta definir f`c y/o fy'):
                    (SecProvider.getNsup1() == 0 || SecProvider.getBsup1() == null ||
                        SecProvider.getNinf1() == 0 ||SecProvider.getBinf1() == null) ? Text('Falta definir refuerzo superior y/o inferior'):
                    (MyProvider.getLSel() == 0.0 || MyProvider.getLSel() == null) ? Text('Falta definir largo') : Text('Falta definir apoyos'),
                  duration: Duration(milliseconds: 1500),
                  width: 280.0, // Width of the SnackBar.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, // Inner padding for SnackBar content.
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ));
              };
            },
            ),
          );
        }),
      ),
    );
  }
}