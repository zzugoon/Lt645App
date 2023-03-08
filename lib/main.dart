import 'package:flutter/material.dart';
import 'package:lt645/result/ResultPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'destination/destination.dart';
import 'home/RootPage.dart';
import 'info/ListPage.dart';
import 'my/MyInfoPage.dart';

Future<void> main() async {
  runApp(const Lt645App());
}

class Lt645App extends StatefulWidget {
  const Lt645App({super.key});

  @override
  State<Lt645App> createState() => _Lt645App();
}

class _Lt645App extends State<Lt645App> with TickerProviderStateMixin<Lt645App> {

  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'Home', Icons.home, Colors.cyan),
    Destination(1, '6/45', Icons.filter_6, Colors.cyan),
    Destination(2, 'Info', Icons.info, Colors.orange),
    Destination(3, 'My', Icons.person, Colors.blue),
  ];

  static List<Widget> pages = <Widget>[
    RootPage(),
    ListPage(destination: allDestinations[1]),
    ResultPage(url:'https://dhlottery.co.kr/common.do?method=main'),
    MyInfoPage(destination: allDestinations[3]),
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<GlobalKey> destinationKeys;
  late final List<AnimationController> destinationFaders;
  late final List<Widget> destinationViews;

  int selectedIndex = 0;

  // AnimationController buildFaderController() {
  //   final AnimationController controller = AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 200));
  //   controller.addStatusListener((AnimationStatus status) {
  //     if (status == AnimationStatus.dismissed) {
  //       setState(() {}); // Rebuild unselected destinations offstage.
  //     }
  //   });
  //   return controller;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'mobilePOP'),
      home: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('6/45 Test'),
            backgroundColor: Colors.grey,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1.0, color: Colors.black12)),
            ),
            height: 50,
            child: const TabBar(
              // padding: EdgeInsets.only(left: 0.0, right: 0.0 ,top: 5.0, bottom: 0.0),
              indicatorColor: Colors.transparent, // indicator 없애기
              unselectedLabelColor: Colors.grey, // 선택되지 않은 tab 색
              labelColor: Colors.black, //
              tabs: <Widget>[
                Tab(
                  icon : Icon(Icons.pin, size: 20.0, ),
                  child: Text('lotto', style: TextStyle(fontSize: 10.0)),
                  iconMargin: EdgeInsets.only(bottom: 5.0),
                ),
                Tab(
                  icon : Icon(Icons.addchart, size: 20.0),
                  child: Text('연금720+', style: TextStyle(fontSize: 10.0)),
                  iconMargin: EdgeInsets.only(bottom: 5.0),
                ),
                Tab(
                  icon : Icon(Icons.person, size: 20.0,),
                  child: Text('당첨확인', style: TextStyle(fontSize: 10.0)),
                  iconMargin: EdgeInsets.only(bottom: 5.0),
                ),
                Tab(
                  icon : Icon(Icons.person, size: 20.0),
                  child: Text('내 정보', style: TextStyle(fontSize: 10.0)),
                  iconMargin: EdgeInsets.only(bottom: 5.0),
                ),
              ],
            ),
          ),
          body: TabBarView( //(2)
            children: pages, // 어떤 아이템을 넣어줄 지
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    permission();

    // if (await Permission.location.isGranted) {
    //   // 권한이 부여되었습니다.
    // }

    // navigatorKeys = List<GlobalKey<NavigatorState>>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
    // destinationFaders = List<AnimationController>.generate(allDestinations.length, (int index) => buildFaderController()).toList();
    // destinationFaders[selectedIndex].value = 1.0;
    // destinationViews = allDestinations.map((Destination destination) {
    //   return FadeTransition(
    //     opacity: destinationFaders[destination.index]
    //         .drive(CurveTween(curve: Curves.fastOutSlowIn)),
    //     child: DestinationView(
    //       destination: destination,
    //       navigatorKey: navigatorKeys[destination.index],
    //     ));
    // }).toList();
  }

  @override
  void dispose() {
    // for (final AnimationController controller in destinationFaders) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  Future<bool> permission() async {
    Map<Permission, PermissionStatus> status = await [Permission.storage].request(); // [] 권한배열에 권한을 작성

    if (await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  // 왜 안되지??
  Tab createTab(text) {
    return Tab(
      icon : const Icon(Icons.person, size: 20.0),
      iconMargin: const EdgeInsets.only(bottom: 5.0),
      child: Text(text, style: const TextStyle(fontSize: 10.0)),
    );
  }

}


