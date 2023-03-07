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

  List listTitle = [
    '생성번호'
    ,'분석, 통계'
    ,'기타'
  ];
  List listSubstance = [
    ['저장목록', '삭제']
    ,['당첨번호 회수','연속 당첨 숫자', '10 단위별 빈도']
    ,['설정', '인증하기', '키워드',' 자주 묻는 질문', '친구초대']
  ];
  List listIcon = [
    Icons.wb_sunny
    ,Icons.brightness_3
    ,Icons.brightness_1
    ,Icons.star
    ,Icons.ac_unit
  ];

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
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 0.0),
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
                      child: Text("프로필 보기",
                        style: TextStyle(fontSize: 10.0),
                      ),
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
                children: [
                  for(var i=0; i<listTitle.length; i++)...[
                    ListTile(
                      title: Text(listTitle[i]),
                    ),
                    for(var j=0; j<listSubstance[i].length; j++)...[
                      ListTile(
                        leading: Icon(listIcon[divideModulo(j, listSubstance[i].length)]),
                        title: Text(listSubstance[i][j]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                    Divider(height: 5,)
                  ],
                ]
                //   ListTile.divideTiles(
                //   tiles: [
                //     for(var i=0; i<10; i++) ... [
                //       ListTile(
                //         leading: Icon(Icons.wb_sunny),
                //         title: Text('Sun'),
                //         trailing: Icon(Icons.keyboard_arrow_right),
                //       ),
                //       ListTile(
                //         leading: Icon(Icons,wb_sunny, brightness_3, star),
                //         title: Text('Moon'),
                //         trailing: Icon(Icons.keyboard_arrow_right),
                //       ),
                //       ListTile(
                //         leading: Icon(Icons.star),
                //         title: Text('Star'),
                //         trailing: Icon(Icons.keyboard_arrow_right),
                //       ),
                //     ]
                //   ],
                // ).toList(),
              ),
            ],
          ),
        ),
      )
    );
  }

  divideModulo(a, b) {
    return a % b;
  }
}