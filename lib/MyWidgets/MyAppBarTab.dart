import 'package:flutter/material.dart';

class tab {
  String txt;
  Icon tabicon;
  Widget func;

  tab({required this.txt, required this.tabicon, required this.func});

  @override
  String toString() {
    return 'tab: {Shape: $txt, $tabicon}';
  }
}

class MyAppBarTab extends StatelessWidget {
  final String titulo;
  final listatab;

  MyAppBarTab({required this.titulo, required this.listatab});

  @override
  Widget build(BuildContext context) {
    var numtabs = listatab.length;
    var ListTab = <Widget>[];
    var ListFunc = <Widget>[];

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
        appBar:
        // MyAppBar('Resultados', context),
        AppBar(
          title: Text(titulo),
          centerTitle: true,
          backgroundColor: Colors.red[900],
          automaticallyImplyLeading: true,
          bottom: TabBar(
            isScrollable: false,
            tabs: ListTab,

          ),
        ),
        body: TabBarView(
          children: ListFunc,
        ),
        // MultiProvider(
        //         providers: [
        //           ChangeNotifierProvider<DemProvider>(
        //             create: (_) => DemProvider(
        //               // ApSel: null,
        //               ),
        //             ),
        //           ],
        //         child: TabBarView(
        //           children: ListFunc,
        //         ),
        //       ),
      ),
    );
  }
}