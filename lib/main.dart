import 'package:flutter/material.dart';
import 'genNum/genNumber.dart';
import 'destination/destination_view.dart';
import 'destination/destination.dart';

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
    Destination(0, 'Home', Icons.home, Colors.teal),
    Destination(1, '6/45', Icons.filter_6, Colors.cyan),
    Destination(2, 'Info', Icons.info, Colors.orange),
    Destination(3, 'My', Icons.person, Colors.blue),
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

  @override
  void initState() {
    super.initState();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    destinationFaders = List<AnimationController>.generate(
        allDestinations.length, (int index) => buildFaderController()).toList();
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
        final NavigatorState navigator =
        navigatorKeys[selectedIndex].currentState!;
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
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: allDestinations.map((Destination destination) {
            return NavigationDestination(
              icon: Icon(destination.icon, color: destination.color),
              label: destination.title,
            );
          }).toList(),
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


