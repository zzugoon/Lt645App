import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lt645/my/SaveNumberData.dart';
import 'package:path_provider/path_provider.dart';

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
    '저장목록'
    ,'분석, 통계'
    ,'기타'
  ];
  List listSubstance = [
    ['목록편집', '모두삭제']
    ,['당첨번호 회수[X]','연속 당첨 숫자[X]', '10 단위별 빈도[X]']
    ,['설정[X]', '인증하기[X]', '키워드[X]',' 자주 묻는 질문[X]', '친구초대[X]']
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
                      child: const Text("프로필 보기",
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ),
                  )
                ],
              ),
              Container(

              ),
              const Divider(
                height: 5,
              ),
              ListTile(
                title: Text(listTitle[0]),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listSubstance[0].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(listIcon[divideModulo(index, listSubstance[0].length)]),
                    title: Text(listSubstance[0][index]),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      if(index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SaveNumberData()),
                        );
                      } else if(index ==1) {
                        _cupertinoDialog(context, '저장한 데이터를 모두 삭제 하시겠습니까?');
                      }
                    },
                  );
                },
              ),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for(var i=1; i<listTitle.length; i++)...[
                    ListTile(
                      title: Text(listTitle[i]),
                    ),
                    for(var j=0; j<listSubstance[i].length; j++)...[
                      ListTile(
                        leading: Icon(listIcon[divideModulo(j, listSubstance[i].length)]),
                        title: Text(listSubstance[i][j]),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SaveNumberData()),
                          );

                          setState(() {

                          });
                        },
                      ),
                    ],
                    const Divider(height: 5,)
                  ],
                ]
              ),
            ],
          ),
        ),
      )
    );
  }

  void _cupertinoDialog(BuildContext context, String msg) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('ALERT'),
        content: Text(msg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('취소'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인'),
            onPressed: () {
              deleteAllData();

              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: '삭제가 완료되었습니다',
                  toastLength: Toast.LENGTH_SHORT
              );
            },
          ),
        ],
      ),
    );
  }

  //=== 파일 저장 ===
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    return File('$path/data.json');
  }

  Future<File> deleteAllData() async {
    print("saveData");
    List<dynamic>? saveData = [];

    // print('data :: $data');
    // saveData?.add(data);

    final file = await _localFile;

    return file.writeAsString(jsonEncode(saveData));
  }

  divideModulo(a, b) {
    return a % b;
  }
}