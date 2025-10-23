import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Google/screens/sign_in_screen.dart';
import 'MyClasses/MyProviders.dart';
import 'firebase_options.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyMenuButton.dart';
import 'package:lonchi_ing_gd/acero/SteelDes.dart';
import 'package:lonchi_ing_gd/concreto/ConcDes.dart';
import 'package:provider/provider.dart';
import 'Reportes/Proyectos.dart';
import 'concreto/Refuerzo.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';

final navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform)
  // .then(
  // (FirebaseApp value) => Get.put(AuthenticationRepository())
      ;
  print('Firebase initialized!');
  // await _initFirebase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WProvider>(
          create: (_) => WProvider(
              LbSel: 0,
              WSizeSel: null,
              WSel: null,
              AceroSel: null
            // LSel: 1.0,
          ),
        ),
        ChangeNotifierProvider<VigProvider>(
          create: (_) => VigProvider(
            BVig: null,
            HVig: null,
            rec: 3,
            fc: 210,
            fy: 4200,
            fyv: 2800,
            Nsup1: 2,
            Nsup2: 0,
            Ninf1: 2,
            Ninf2: 0,
            Binf1: null,
            Binf2: RebarCalc()[0],
            Bsup1: null,
            Bsup2: RebarCalc()[0],
            Baro: RebarCalc()[2],
            sep: 15,
          ),
        ),
        ChangeNotifierProvider<LosaProvider>(
          create: (_) => LosaProvider(
            BVig: 100,
            HVig: null,
            rec: 3,
            fc: 210,
            fy: 4200,
            fyv: 2800,
            Nsup1: 20,
            Nsup2: 20,
            Ninf1: 20,
            Ninf2: 20,
            Binf1: null,
            Binf2: RebarCalc()[2],
            Bsup1: null,
            Bsup2: RebarCalc()[2],
            Baro: RebarCalc()[2],
            sep: 15,
          ),
        ),
        ChangeNotifierProvider<DemProvider>(
          create: (_) => DemProvider(
            LSel: null,
            Ancho: 0,
            ApSel: null,
            wCPSel: 0.0,
            wCTSel: 0.0,
            // Tipo: 1,
          ),
        ),
        ChangeNotifierProvider<ResultProvider>(
          create: (_) => ResultProvider(
            // LSel: 1.0,
            // Ancho: 1.0,
            // ApSel: null,
            // Tipo: 1,
          ),
        ),
      ],
      child: FutureBuilder(
          future: Init.instance.initialize(),
          builder: (context, AsyncSnapshot snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.red[900],
                // primarySwatch: Colors.red[900],
                // scaffoldBackgroundColor: Colors.grey[900],
                // tabBarTheme:
                // brightness: Brightness.dark,
              ),
              home: MyApp(),
            );
          }
      ),
    ),
  );
}

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  onButtonTap(Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Lonchi Ing",
          style: TextStyle(
            color: Colors.grey[400],),),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            MyMenuButton(
              titulo: "Diseño en acero",
              actionTap: () {
                onButtonTap(
                  SteelDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Diseño en concreto",
              actionTap: () {
                onButtonTap(
                  ConcDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Reportes de inspección",
              actionTap: () {
                onButtonTap(
                  Proyectos(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Google Sign In",
              actionTap: () {
                onButtonTap(
                  SignInScreen(),
                );
              },
            ),
            // MyMenuButton(
            //   titulo: "Google Sign In (Viejo)",
            //   actionTap: () {
            //     onButtonTap(
            //       GoogleDriveLogin(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
// This is where you can initialize the resources needed by your app while
// the splash screen is displayed.  Remove the following example because
// delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 2));
  }
}