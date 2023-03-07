import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/destination.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: 'Sample Text');
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    const int itemCount = 20;
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.purple,
      fixedSize: const Size.fromHeight(128),
      textStyle: Theme.of(context).textTheme.headlineSmall,
    );

    return Scaffold(
      backgroundColor: widget.destination.color[50],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 0.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 0.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Icon(Icons.info, size: 50,),
                    ),
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text("zzuGoon", textAlign: TextAlign.center,)
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Line 1'),
                          Text('Line 2'),
                        ],
                      )
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {

                        setState(() {

                        });
                      },
                      child: Text("프로필 보기"),
                    ),
                  )
                ],
              ),
              Container(

              ),
              Divider(
                height: 5,
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    for(var i=0; i<10; i++) ... [
                      ListTile(
                        leading: Icon(Icons.wb_sunny),
                        title: Text('Sun'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_3),
                        title: Text('Moon'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Star'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ]
                  ],
                ).toList(),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: itemCount,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              //         child: OutlinedButton(
              //           style: buttonStyle.copyWith(
              //             backgroundColor: MaterialStatePropertyAll<Color>(Color.lerp(
              //                 Colors.purple[100],
              //                 Colors.white,
              //                 index / itemCount)!),
              //           ),
              //           onPressed: () {
              //             Navigator.pushNamed(context, '/text');
              //           },
              //           child: Text('Push /text [$index]'),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      )
    );
  }
}