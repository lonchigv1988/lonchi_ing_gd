import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';

import 'Reportes.dart';

// import 'TrasGanch.dart';

class SearchProyectosTitulo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SearchProyectosTituloType();
  }
}
class SearchProyectosTituloType extends StatefulWidget {

  @override
  SearchProyectosTituloTypeState createState() {
    return SearchProyectosTituloTypeState();
  }
}

class SearchProyectosTituloTypeState extends State<SearchProyectosTituloType> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String _filtro = "";

  onButtonTap(Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
    // Navigator.push(
    // context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // final MyProvider = Provider.of<DemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: MyAppBar('Buscar proyectos', context),
      // AppBar(
      //   title: Text("Diseño en acero"),
      //   centerTitle: true,
      //   backgroundColor: Colors.red,
      // ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Colors.grey[900],
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.search,color: Colors.grey),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Título:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 17,
                            )),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText: 'Ingresar texto',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[900],
                              height: 1.5,
                            ),
                          ),
                          onChanged: (value) {
                            _filtro = value;
                            print(_filtro);
                            setState(() {
                              _dbHelper.getProyectosFiltered(_filtro);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getProyectosFiltered(_filtro),
                        builder: (context, AsyncSnapshot snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              // padding: const EdgeInsets.fromLTRB(3,0,3,3),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Reportes(
                                          proyecto: snapshot.data[index],
                                        ),
                                      ),
                                    ).then(
                                          (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(3,5,3,3),
                                    child: ProyectoWidget(
                                      title: snapshot.data[index].title,
                                      count: snapshot.data[index].count == null ? 0 : snapshot.data[index].count,
                                    ),),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}