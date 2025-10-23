import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/acero/WDes.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyMenuButton.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'package:provider/provider.dart';
import '../MyClasses/MyProviders.dart';

class SteelDes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Steeltype();
  }
}
class Steeltype extends StatefulWidget {
@override
SteeltypeState createState() {
  return SteeltypeState();
}
}

class SteeltypeState extends State<Steeltype> {

  onButtonTap(Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
    // Navigator.push(
        // context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final MyProvider = Provider.of<DemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: MyAppBar('Diseño de acero', context),
      // AppBar(
      //   title: Text("Diseño en acero"),
      //   centerTitle: true,
      //   backgroundColor: Colors.red,
      // ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            MyMenuButton(
              titulo: "Diseño de elementos W",
              actionTap: () {
                onButtonTap(
                  WDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Diseño de elementos W prueba",
              actionTap: () {
                onButtonTap(
                  WDes(),
                );
              },
            ),
            MyMenuButton(
              titulo: "Diseño de elementos otros...",
              actionTap: () {
                onButtonTap(
                  WDes(),
                );
              },
            ),
            // MyMenuButton(
            //   title: "Fetch Data JSON",
            //   actionTap: () {
            //     onButtonTap(
            //       MainFetchData(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //     title: "Persistent Tab Bar",
            //     actionTap: () {
            //       onButtonTap(
            //         MainPersistentTabBar(),
            //       );
            //     }),
            // MyMenuButton(
            //   title: "Collapsing Toolbar",
            //   actionTap: () {
            //     onButtonTap(
            //       MainCollapsingToolbar(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //   title: "Hero Animations",
            //   actionTap: () {
            //     onButtonTap(
            //       MainHeroAnimationsPage(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //   title: "Size and Positions",
            //   actionTap: () {
            //     onButtonTap(
            //       MainSizeAndPosition(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //   title: "ScrollController and ScrollNotification",
            //   actionTap: () {
            //     onButtonTap(
            //       MainScrollController(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //   title: "Apps Clone",
            //   actionTap: () {
            //     onButtonTap(
            //       MainAppsClone(),
            //     );
            //   },
            // ),
            // MyMenuButton(
            //   title: "Animations",
            //   actionTap: () {
            //     onButtonTap(
            //       MainAnimations(),
            //     );
            //   },
            // ),
//             MyMenuButton(
//               title: "Communication Widgets",
//               actionTap: () {
//                 onButtonTap(
//                   MainCommunicationWidgets(),
//                 );
//               },
//             ),
//             MyMenuButton(
//               title: "Split Image",
//               actionTap: () {
//                 onButtonTap(MainSplitImage());
//               },
//             ),
//             MyMenuButton(
//               title: "Custom AppBar & SliverAppBar",
//               actionTap: () {
//                 onButtonTap(MainAppBarSliverAppBar());
//               },
//             ),
//             MyMenuButton(
//               title: "Menu Navigations",
//               actionTap: () {
//                 onButtonTap(MainMenuNavigations());
//               },
//             ),
          ],
        ),
      ),
    );
  }
}