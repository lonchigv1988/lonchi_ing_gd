import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/acero/AISCProp.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyFunc.dart';
import '../MyClasses/MyProviders.dart';


class MyTab_W extends StatelessWidget {
  final String titulo;
  final listatab;
  final Widget loc;
  // var SeccSelec;
  // var LongSelec;
  // var ApoyoSelec;

  MyTab_W({required this.titulo, required this.listatab, required this.loc});

  // MyTab_W({this.titulo, this.listatab, this.loc,
  //   this.SeccSelec, this.LongSelec,this.ApoyoSelec});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final SecProvider = Provider.of<WProvider>(context, listen: false);
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
                    MyProvider.setAncho(0);
                    MyProvider.setwCPSel(0);
                    MyProvider.setwCTSel(0);
                    MyProvider.setApSel(null);
                    SecProvider.setLbSel(0);
                    SecProvider.setSecSel(null);
                    SecProvider.setSecSize(null);
                    SecProvider.setAceroSel(AceroCalc()[18]);
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
        bottomNavigationBar: Consumer2<WProvider, DemProvider>(
            builder: (context, SecProvider, MyProvider, child) {
          return BottomAppBar(
            color: Colors.red[900],
            child: IconButton(
              icon: Icon(Icons.calculate),
              color: SecProvider.getSecSel() != null &&
                  MyProvider.getLSel() != 0.0 &&
                  MyProvider.getApSel() != null &&
                  SecProvider.getAceroSel() != null
                  ? Colors.black
                  : Colors.grey[600],
                iconSize: 45,
            onPressed: () {
              if (SecProvider.getSecSel() != null &&
                  MyProvider.getLSel() != 0.0 &&
                  MyProvider.getApSel() != null &&
                  SecProvider.getAceroSel() != null) {

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

                  // Ixx = MyProvider.getIxx();
                  // EE = MyProvider.getEE();

                  wCPP = Ancho*wCP+PP;
                  wCTT = Ancho*wCT;

                //CALCULO DE DEMANDAS
                  wCU = MaxVal([1.4*wCPP, 1.2*wCPP+1.6*wCTT]);

                  MuMax = round(MaxVal([MaxVal(MDis),0])*wCU*L*L,0);
                  MuMin = round(MinVal([MinVal(MDis),0])*wCU*L*L,0);
                  VuMax = round(MaxVal([MaxVal(VDis), MinVal(VDis)*-1])*wCU*L,0);

                  ResProvider.setMupos(MuMax!);
                  ResProvider.setMuneg(MuMin!);
                  ResProvider.setVumax(VuMax!);

                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => loc));
              };
            },
            ),
          );
        }),
        // floatingActionButton: Consumer2 <WProvider, DemProvider>
        //   (builder: (context, SecProvider, MyProvider, child) {
        //   return Container(
        //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10.0),
        //           color: Colors.grey[400],
        //           border: Border.all()),
        //       child: FloatingActionButton.extended(
        //         elevation: 0,
        //         backgroundColor: Colors.grey[400],
        //         label: Text(
        //           'Calcular',
        //           style: TextStyle(
        //             color: SecProvider.getSecSel() != null &&
        //                     MyProvider.getLSel() != 0.0 &&
        //                     MyProvider.getApSel() != null &&
        //                     SecProvider.getAceroSel() != null
        //                 ? Colors.black
        //                 : Colors.grey[600],
        //             fontSize: 18,
        //           ),
        //         ),
        //         onPressed: () {
        //           if (SecProvider.getSecSel() != null &&
        //               MyProvider.getLSel() != 0.0 &&
        //               MyProvider.getApSel() != null &&
        //               SecProvider.getAceroSel() != null) {
        //             Navigator.push(
        //                 context, MaterialPageRoute(builder: (BuildContext context) => loc));
        //           };
        //         },
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}