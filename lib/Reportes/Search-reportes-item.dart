import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import '../MyClasses/MyItems.dart';
import 'itempage.dart';
import 'itempageDesc.dart';

class SearchReportesItem extends StatelessWidget {
  final int proyectoId;
  final String proyecto;
  SearchReportesItem({required this.proyectoId, required this.proyecto});


  @override
  Widget build(BuildContext context) {
    return SearchReportesItemType(proyectoId, proyecto);
  }
}
class SearchReportesItemType extends StatefulWidget {
  final int? proyectoId;
  final String proyecto;
  SearchReportesItemType(this.proyectoId, this.proyecto);

  @override
  SearchReportesItemTypeState createState() {
    // return SearchReportesItemTypeState();
    return SearchReportesItemTypeState(proyectoId!, proyecto);
  }
}

class SearchReportesItemTypeState extends State<SearchReportesItemType> {
  final int proyectoId;
  final String proyecto;
  SearchReportesItemTypeState(this.proyectoId, this.proyecto);

  DatabaseHelper _dbHelper = DatabaseHelper();

  String _filtro = "";
  int _proyectoId = 0;

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
                        child: Text("Descripción:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
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
                              _dbHelper.getItemsWithReportInfo(proyectoId, _filtro);
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
                        future: _dbHelper.getItemsWithReportInfo(proyectoId , _filtro),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                          final items = snapshot.data!;

                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              itemCount: items == null ? 0 : items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];

                                return GestureDetector(
                                  onTap: () async {
                                    final itemObject = Items(
                                      id: item['id'],
                                      proyectoId: item['proyectoId'],
                                      reportId: item['reportId'],
                                      description: item['description'],
                                      photo: item['photo'],
                                      count: item['count'],
                                    );
                                    WidgetsFlutterBinding.ensureInitialized();
                                    final cameras = await availableCameras();
                                    final firstCamera = cameras.first;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItempageDesc(
                                          item: itemObject,
                                          camera: firstCamera,
                                          proyecto: proyecto,
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
                                    child: ItemSearchResultWidget(
                                      id: index + 1,
                                      desc: item['description'] ?? "",
                                      reportTitle: item['reportTitle'] ?? "",
                                      reportDate: item['reportDate'] ?? "",
                                    ),
                                  ),
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