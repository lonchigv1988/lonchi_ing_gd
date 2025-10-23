import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/Reportes/reportpage.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'package:intl/intl.dart';

// import 'TrasGanch.dart';

class SearchReportes extends StatelessWidget {
  final int? proyectoId;
  SearchReportes({this.proyectoId});


  @override
  Widget build(BuildContext context) {
    return SearchReportesType(proyectoId);
  }
}
class SearchReportesType extends StatefulWidget {
  final int? proyectoId;
  SearchReportesType(this.proyectoId);

  @override
  SearchReportesTypeState createState() {
    // return SearchReportesTypeState();
    return SearchReportesTypeState(proyectoId!);
  }
}

class SearchReportesTypeState extends State<SearchReportesType> {
  final int proyectoId;
  SearchReportesTypeState(this.proyectoId);

  DatabaseHelper _dbHelper = DatabaseHelper();

  String _filtro = "";
  int _proyectoId = 0;
  // int _reportId = widget.proyectoId;
  var _Dateini = TextEditingController();
  var _Datefin = TextEditingController();
  // _Dateini = DateTime(2000);
  // _Dateini.text = DateFormat('dd/MM/yyyy').format(DateTime(2000));

  int DateIni = DateTime(2000).millisecondsSinceEpoch;
  int DateFin = DateTime(2100).millisecondsSinceEpoch;

  Future<Null> IniDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      // initialDate: DateTime.now(),
      initialDate:
      _Dateini.text != ""
          ? DateFormat('dd/MM/yyyy').parse(_Dateini.text)
          : DateTime.now(),
      lastDate: DateTime(2100),

    );
    if (picked != null) {
      DateIni = picked.millisecondsSinceEpoch;
      // await _dbHelper.updateReportDate(_reportId, DateFormat('dd/MM/yyyy').format(picked));
      // print(picked.toString());
      setState(() {
        _Dateini.text = DateFormat('dd/MM/yyyy').format(picked);
        // print( _reportDateController);
      });
    }
  }

  Future<Null> FinDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      // initialDate: DateTime.now(),
      initialDate:
      _Datefin.text != ""
          ? DateFormat('dd/MM/yyyy').parse(_Datefin.text)
          : DateTime.now(),
      lastDate: DateTime(2100),

    );
    if (picked != null) {
      DateFin = picked.millisecondsSinceEpoch;
      // await _dbHelper.updateReportDate(_reportId, DateFormat('dd/MM/yyyy').format(picked));
      // print(picked.toString());
      setState(() {
        _Datefin.text = DateFormat('dd/MM/yyyy').format(picked);
        // print( _reportDateController);
      });
    }
  }

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
      appBar: MyAppBar('Buscar reportes', context),
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
                              _dbHelper.getReportsFiltered(proyectoId, _filtro, DateIni, DateFin);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: FutureBuilder(
                              initialData: [],
                              future: _dbHelper.getProyectoReports(_proyectoId),
                              builder: (context, snapshot) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () async {
                                    IniDate(context);
                                  },
                                );
                              }
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Fecha inicial:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            )),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          enabled: false,
                          controller: _Dateini,
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
                            hintText: 'Fecha',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[900],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: FutureBuilder(
                              initialData: [],
                              future: _dbHelper.getProyectoReports(_proyectoId),
                              builder: (context, snapshot) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () async {
                                    FinDate(context);
                                  },
                                );
                              }
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Fecha final:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            )),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          enabled: false,
                          controller: _Datefin,
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
                            hintText: 'Fecha',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[900],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getReportsFiltered(proyectoId, _filtro, DateIni, DateFin),
                        // future: _dbHelper.getReportsFiltered2(proyectoId, _filtro),
                        builder: (context, AsyncSnapshot snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              // padding: const EdgeInsets.fromLTRB(3,0,3,3),
                              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Reportpage(
                                          report: snapshot.data[index],
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
                                    child: TaskCardWidget(
                                      title: snapshot.data[index]?.title,
                                      date: snapshot.data[index]?.date,
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