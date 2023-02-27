import 'package:flutter/material.dart';
import 'genNum/genNumber.dart';
import 'destination/destinationView.dart';
import 'destination/destination.dart';
import 'home/RootPage.dart';
import 'info/ListPage.dart';
import 'my/TextPage.dart';

void main() {
  runApp(const MaterialApp(home: Lt645App()));
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
    RootPage(destination: allDestinations[0]),
    ListPage(destination: allDestinations[1]),
    TextPage(destination: allDestinations[2])
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<GlobalKey> destinationKeys;
  late final List<AnimationController> destinationFaders;
  late final List<Widget> destinationViews;
  int selectedIndex = 0;

  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {}); // Rebuild unselected destinations offstage.
      }
    });
    return controller;
  }

  _onItemTapped(int index) { // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      selectedIndex = index;
      //Navigator.pushNamed(context, '/list');
      switch(index) {
        case 0:
          Navigator.pushNamed(context, '/');
          break;
        case 1:
          Navigator.pushNamed(context, '/list');
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage(destination: allDestinations[index])));
          break;
        default :
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
    destinationFaders = List<AnimationController>.generate(allDestinations.length, (int index) => buildFaderController()).toList();
    destinationFaders[selectedIndex].value = 1.0;
    destinationViews = allDestinations.map((Destination destination) {
      return FadeTransition(
        opacity: destinationFaders[destination.index]
            .drive(CurveTween(curve: Curves.fastOutSlowIn)),
        child: DestinationView(
          destination: destination,
          navigatorKey: navigatorKeys[destination.index],
        ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = navigatorKeys[selectedIndex].currentState!;
        if (!navigator.canPop()) {
          return true;
        }
        navigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final int index = destination.index;
              final Widget view = destinationViews[index];
              if (index == selectedIndex) {
                destinationFaders[index].forward();
                return Offstage(offstage: false, child: view);
              } else {
                destinationFaders[index].reverse();
                if (destinationFaders[index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            print('bottomNav click :: $value');
            _onItemTapped(value);
          },
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon : Icon(Icons.pin),
              label: '번호생성'
            ),
            BottomNavigationBarItem(
              icon : Icon(Icons.addchart),
              label: '당첨번호',
            ),
            BottomNavigationBarItem(
              icon : Icon(Icons.person),
              label: '내 정보'
            ),
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final AnimationController controller in destinationFaders) {
      controller.dispose();
    }
    super.dispose();
  }


}


