import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lt645/model/BallNumberImage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saf/saf.dart';
import 'package:shared_storage/shared_storage.dart';

import '../genNum/genNumber.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  static const int _lotteryNumber = 45;
  static const List<int> _lotteryNumberList = [0,10,20,30,40];

  late List<List<bool>> partialSelections;
  late List<List<bool>> unPartialSelections;

  List<dynamic> numList = [['1번','2번','3번','4번','5번','6번']];
  List<dynamic> numMapList = [];
  List<Map> tableHeader = [
    {'col' : 'A', 'type' : '자동'}
    ,{'col' : 'B', 'type' : '자동'}
    ,{'col' : 'C', 'type' : '자동'}
    ,{'col' : 'D', 'type' : '자동'}
    ,{'col' : 'E', 'type' : '자동'}
  ];

  String rangePercent = '1';
  late TabController _tabController;

  TextEditingController getMinNum = TextEditingController(text: "1");
  TextEditingController getMaxNum = TextEditingController(text: "45");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // toggle bool 리스트 생성
    partialSelections = initPartialSelections();
    unPartialSelections = initPartialSelections();
  }

  @override
  void dispose() {
    super.dispose();
    getMinNum.dispose();
    getMaxNum.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineSmall = Theme.of(context).textTheme.bodySmall!;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      // backgroundColor: widget.destination.color,
      // visualDensity: VisualDensity.standard,
      // padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      textStyle: headlineSmall,
    );

    var minNum = getMinNum.text;
    var maxNum = getMaxNum.text;
    GenNumber genNumber = GenNumber();

    var numFormat = NumberFormat('###,###,###,###');
    rangePercent = numFormat.format(genNumber.calRate(int.parse(minNum), int.parse(maxNum)));

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child:ElevatedButton(
                      child: const Text('번호 생성'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        minimumSize: Size(50, 40),
                      ),
                      onPressed: () {
                        //create Number
                        print('createNumber');

                        //-validation
                        if(numMapList.length > 4) {
                          _cupertinoDialog(context, '최대로 생성 가능한 번호는 5개 입니다.');
                          return;
                        }

                        //-tab index 별 생성 로직
                        if(_tabController.index == 0) {
                          var minNum = getMinNum.text;
                          var maxNum = getMaxNum.text;
                          var subNum = int.parse(maxNum) - int.parse(minNum);

                          if(subNum < 10) {
                            _cupertinoDialog(context, '생성할 번호 범위가 너무 작습니다.(최소 10 이상)');
                            return;
                          }
                          setState(() {
                            // ==== "번호 생성하기 start" ====
                            GenNumber genNumber = GenNumber();
                            numMapList.add(
                                genNumber.fn_genNumTypeA(int.parse(minNum), int.parse(maxNum)));
                            // ===== "번호 생성하기 end" =====
                          });

                        } else if(_tabController.index == 1) {
                          var tempList = partialSelections.expand((x) => x).toList();
                          var boolCountList = tempList.where((e) => e == true);
                          var numberList = [];

                          if(boolCountList.length > 6) {
                            _cupertinoDialog(context, '선택한 번호가 너무 많습니다.');
                            return;
                          }

                          for(var i=0; i<tempList.length; i++) {
                            if(tempList[i] == true) numberList.add(i+1);
                          }

                          setState(() {
                            // ==== "번호 생성하기 start" ====
                            GenNumber genNumber = GenNumber();
                            numMapList.add(
                                genNumber.fn_genNumTypeB(numberList));
                            // ===== "번호 생성하기 end" =====
                          });

                        } else if(_tabController.index == 2) {
                          var tempList = unPartialSelections.expand((x) => x).toList();
                          var boolCountList = tempList.where((e) => e == true);
                          var numberList = [];

                          if(boolCountList.length > 20) {
                            _cupertinoDialog(context, '선택한 번호가 너무 많습니다.');
                            return;
                          }

                          for(var i=0; i<tempList.length; i++) {
                            if(tempList[i] == true) numberList.add(i+1);
                          }

                          setState(() {
                            // ==== "번호 생성하기 start" ====
                            GenNumber genNumber = GenNumber();
                            numMapList.add(
                                genNumber.fn_genNumTypeC(numberList));
                            // ===== "번호 생성하기 end" =====
                          });
                        }
                      },
                    ),
                  ),
                  sizeBox(10.0, 0.0),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: ElevatedButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          minimumSize: Size(50, 40)
                      ),
                      child: const Text('초기화',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal
                          )
                      ),
                      onPressed: () {
                        setState(() {
                          if(_tabController.index == 0 ) {
                            numMapList.clear();
                            initRangeSelections();
                          } else if(_tabController.index == 1) {
                            numMapList.clear();
                            partialSelections = initPartialSelections();
                          } else if(_tabController.index == 2) {
                            numMapList.clear();
                            unPartialSelections = initPartialSelections();
                          }
                        });
                      },
                    ),
                  ),
                  sizeBox(10.0, 0.0),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: ElevatedButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          minimumSize: Size(50, 40)
                      ),
                      child: const Text('불러오기'),
                      onPressed: () {
                        loadData();
                        setState(() {
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            sizeBox(0.0, 10.0),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.black12
                ),
                // indicatorColor: Colors.transparent, // indicator 없애기
                // overlayColor: MaterialStatePropertyAll(Colors.black),
                unselectedLabelColor: Colors.grey, // 선택되지 않은 tab 색,
                labelColor: Colors.black, //
                tabs: const <Widget>[
                  Tab(
                    child: Text('범위지정',
                    style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Tab(
                    child: Text('선택포함',
                    style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Tab(
                    child: Text('선택제외',
                    style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Tab(
                    child: Text('Placeholder',
                    style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: TabBarView(
                controller: _tabController,
                children: [
                  tabItemRange(),
                  tabItemPartial(),
                  tabItemUnPartial(),
                  Placeholder(),
                ],
              ),
            ),
            //*temp*, //*temp*
            sizeBox(0.0, 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: SizedBox(
                height: 260,
                child: Table(
                  border: TableBorder.all(
                    color: Colors.black12,
                    width: 2.0,
                  ),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(40),
                    1: FixedColumnWidth(60),
                    2: FlexColumnWidth(),
                    3: FixedColumnWidth(60),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    for(var i=0; i<tableHeader.length; i++)
                      createTableRow(tableHeader[i]['col'], tableHeader[i]['type'], i),
                  ],
                ),
              ),
            ),
            // listView(), //***** temp *****
          ],
        )
    );
  }

  /*=================================
  ============ widget ===============
  =================================*/
  sizeBox(width, heights) {
    return SizedBox(width: width ,height: heights);
  }

  Widget numberRow(numColor, numText) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(numColor),
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [Color(numColor).withOpacity(0.1), Color(numColor)],
              stops: [0.1, 0.6],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft

          )
        // borderRadius: BorderRadius.circular(30)
      ),
      child: Text(numText,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: "wel_Regular",
            fontSize: 13,
            fontWeight: FontWeight.normal
        ),
      ),
    );
  }

  createTableRow(fr, se, rowNo) {
    return TableRow (
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 50,
          color: Colors.black12,
          child: Text(fr,
            style: const TextStyle(
                fontFamily: "on_goelip",
                fontSize: 30,
                fontWeight: FontWeight.normal
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            alignment: Alignment.center,
            width: null,
            color: Colors.white,
            child: Text(se,
              style: const TextStyle(
                  fontFamily: "on_goelip",
                  fontSize: 25,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 50,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for(var i=1; i<=numMapList.length; i++)
                if(numMapList.length == rowNo+i)
                  for(var j=0; j<numMapList[rowNo].length; j++)
                    numberRow(numMapList[rowNo][j]['color'], numMapList[rowNo][j]['number']),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: Size(50, 35)
            ),
            child: const Text('저장',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            onPressed: () {
              // print(numMapList[rowNo]);
              if(numMapList.length < rowNo+1){
                Fluttertoast.showToast(
                    msg: '저장할 데이터가 없습니다',
                    toastLength: Toast.LENGTH_SHORT
                );
                return;
              }

              saveData(numMapList[rowNo]);
              Fluttertoast.showToast(
                msg: '저장 되었습니다',
                toastLength: Toast.LENGTH_SHORT
              );
            },
          ),
        ),
      ],
    );
  }

  tabItemRange () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Container( ////////////////// selectRange //////////////////
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10.0),
                height: 30,
                child: const Text("생성 범위",
                  // style: TextStyle(
                  //   fontFamily: "on_goelip",
                  //   fontSize: 20,
                  //   fontWeight: FontWeight.normal
                  // )
                ),
              )
            ),
            Flexible(
            fit: FlexFit.tight,
            child: Container(
              height: 30,
              padding: EdgeInsets.only(right: 10.0),
              child: TextField(
                readOnly: true,
                controller: getMinNum,
                onTap: () => {
                  numberPickerDialog(context, getMinNum.text, 'min')
                },
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                  // labelStyle: TextStyle(fontFamily: "on_goelip", fontSize: 25, fontWeight: FontWeight.normal),
                  labelText: "최소값",
                  ),
                ),
              )
            ),
            Flexible(
            fit: FlexFit.tight,
            child: Container(
              height: 30,
              padding: EdgeInsets.only(right: 10.0),
              child: TextField(
                readOnly: true,
                controller: getMaxNum,
                onTap: () => {
                  numberPickerDialog(context, getMaxNum.text, 'max')
                },
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                // labelStyle: const TextStyle(
                //   fontFamily: "on_goelip",
                //   fontSize: 25,
                //   fontWeight:
                //   FontWeight.normal
                //   ),
                labelText: "최대값",
                ),
              ),
            )
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                height: 30,
                child: const Text("당첨 확률 : ",
                style: TextStyle(
                  // fontFamily: "on_goelip",
                  fontSize: 10,
                  fontWeight: FontWeight.normal
                  )
                ),
              )
            ),
            Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text('1 / $rangePercent',
                style: const TextStyle(
                  // fontFamily: "on_goelip",
                  fontSize: 10,
                  fontWeight: FontWeight.normal
                  )
                ),
              )
            ),
            ],
          ),
        ),
        sizeBox(0.0, 10.0),
        Container( ////////////////// ballImage //////////////////
          height: 80,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  for(var i=1; i<6; i++)...[
                    ballNoImage(i),
                  ],
                  sizeBox(10.0, 20.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  sizeBox(20.0, 10.0),
                  for(var i=6; i<10; i++)...[
                    ballNoImage(i),
                  ],
                  ballNoImage(0),
                ],
              )
            ],
          )
        ),
      ],
    );
  }

  tabItemPartial() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // sizeBox(0.0, 10.0),
          const Text('선택한 숫자를 포함하여 추첨번호를 생성합니다',
          style: TextStyle(fontSize: 12)),
          const Text('(최대 6개 선택 가능)',
              style: TextStyle(fontSize: 10)),
          for(var i=0; i<_lotteryNumberList.length; i++)...[
            createToggleButtons(_lotteryNumberList[i], i, partialSelections),
          ]
        ],
      ),
    );
  }

  tabItemUnPartial() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // sizeBox(0.0, 10.0),
          const Text('선택한 숫자를 제외하여 추첨번호를 생성합니다',
            style: TextStyle(fontSize: 12)),
          const Text('(최대 20개 선택 가능)',
              style: TextStyle(fontSize: 10)),
          for(var i=0; i<_lotteryNumberList.length; i++)...[
            sizeBox(0.0, 1.0),
            createToggleButtons(_lotteryNumberList[i], i, unPartialSelections),
          ]
        ],
      ),
    );
  }

  createToggleButtons(number, idx, selections) {
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          selections[idx][index] = !selections[idx][index];
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      isSelected: selections[idx],
      constraints: const BoxConstraints(
        minHeight: 33.0,
        minWidth: 33.0,
      ),
      renderBorder: false,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      children: <Widget>[
        if(number == 40)...[
          for(var i=0; i<5; i++)...[
            createPartialNumber(i+number, idx, i, selections)
          ]
        ]else...[
          for(var i=0; i<10; i++)...[
            createPartialNumber(i+number, idx, i, selections)
          ]
        ]
      ],
    );
  }

  createPartialNumber(number, idx, listIndex, selections) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        shape: BoxShape.circle,
        // You can use like this way or like the below line
        //borderRadius: new BorderRadius.circular(30.0),
        color: changePartialColor(idx, listIndex, selections)
      ),
      alignment: Alignment.center,
      child: Text((number+1).toString(),
        style: TextStyle(
          color: selections[idx][listIndex] ? Colors.white : Colors.black38,
        ),
      ),
    );
  }

  changePartialColor (idx, listIndex, selections) {
    // partialSelections[idx][listIndex] ? Colors.red : Colors.grey,
    if(idx == 0) {
      return selections[idx][listIndex] ? Color(0xFFFFAB00) : Colors.grey;
    } else if(idx == 1) {
      return selections[idx][listIndex] ? Color(0xFF0D47A1) : Colors.grey;
    } else if(idx == 2) {
      return selections[idx][listIndex] ? Color(0xFFC62828) : Colors.grey;
    } else if(idx == 3) {
      return selections[idx][listIndex] ? Color(0xFF424242) : Colors.grey;
    } else if(idx == 4) {
      return selections[idx][listIndex] ? Color(0xFF2E7D32) : Colors.grey;
    }
  }

  /*==================================
  ============= method ===============
  ==================================*/

  initRangeSelections() {
    getMinNum.text = "1";
    getMaxNum.text = "45";
  }

  List<List<bool>> initPartialSelections() {
    List<List<bool>> tempList = [];

    for(var i=0; i<_lotteryNumberList.length; i++) {
      List<bool> tempNumberList = [];
      int forNum = (_lotteryNumberList[i] == 40) ? 5 : 10;

      for(var j=0; j<forNum; j++) {
        tempNumberList.add(false);
      }
      tempList.add(tempNumberList);
    }
    return tempList;
  }
  
  //=== 파일 저장 ===
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    return File('$path/data.json');
  }

  Future<File> saveData(List dataList) async {
    print("saveData");
    List<dynamic>? saveData = [];

    // 기존 파일 불러오기
    saveData = await loadData();

    // 데이터 저장하기
    Map<String, dynamic> data = {
      // 'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'date' : '2023-03-14',
      'idx1' : dataList[0]['number'],
      'idx2' : dataList[1]['number'],
      'idx3' : dataList[2]['number'],
      'idx4' : dataList[3]['number'],
      'idx5' : dataList[4]['number'],
      'idx6' : dataList[5]['number'],
      'color1' : dataList[0]['color'],
      'color2' : dataList[1]['color'],
      'color3' : dataList[2]['color'],
      'color4' : dataList[3]['color'],
      'color5' : dataList[4]['color'],
      'color6' : dataList[5]['color'],
    };

    saveData?.add(data);

    // final file = File('data.json');
    final file = await _localFile;

    // return await file.writeAsString(jsonEncode(data));
    return file.writeAsString(jsonEncode(saveData));
  }

  Future<List?> loadData() async {
    try {
      // 파일 읽기.
      final file = await _localFile;

      if (await file.exists()) {
        final jsonString = await file.readAsString();

        if(jsonString != null || jsonString != 'null') {
          List<dynamic> data = jsonDecode(jsonString);

          return data;
        }
      }
    } catch (e) {
      // 에러가 발생할 경우 0을 반환.
      return null;
    }
    return null;
  }

  // Future<void> exportFile({
  //   required String csvData,
  //   required String fileName,
  // }) async {
  //   Uri? selectedUriDir;
  //   final pref = await SharedPreferences.getInstance();
  //   final scopeStoragePersistUrl = pref.getString('scopeStoragePersistUrl');
  //
  //   // Check User has already grant permission to any directory or not
  //   if (scopeStoragePersistUrl != null &&
  //       await isPersistedUri(Uri.parse(scopeStoragePersistUrl)) &&
  //       (await exists(Uri.parse(scopeStoragePersistUrl)) ?? false)) {
  //     selectedUriDir = Uri.parse(scopeStoragePersistUrl);
  //   } else {
  //     selectedUriDir = await openDocumentTree();
  //     await pref.setString('scopeStoragePersistUrl', selectedUriDir.toString());
  //   }
  //   if (selectedUriDir == null) {
  //     return false;
  //   }
  //   try {
  //     final existingFile = await findFile(selectedUriDir, fileName);
  //     if (existingFile != null && existingFile.isFile) {
  //       debugPrint("Found existing file ${existingFile.uri}");
  //       await delete(existingFile.uri);
  //     }
  //     final newDocumentFile = await createFileAsString(
  //       selectedUriDir,
  //       mimeType: AppConstants.csvMimeTypeWhileExport,
  //       content: csvData,
  //       displayName: fileName,
  //     );
  //     return newDocumentFile != null;
  //   } catch (e) {
  //     debugPrint("Exception while create new file: ${e.toString()}");
  //     return false;
  //   }
  // }

  tempWrite() async {
    var tempSaf = await Saf.getDynamicDirectoryPermission();

    var myFile = File('file.txt');

    final filename = 'file.txt';
    var file = await File(filename).writeAsString('some content');

    print(file);

  }

  tempRead() {
    File('file.txt').readAsString().then((String contents) {
      print(contents);
    });
  }

  Future<void> createFileBySAF(String fileName, Uint8List uint8list) async {

    /*From: shared_storage: ^0.2.0*/
    Uri? uri = await openDocumentTree();

    /*From: saf: ^1.0.3+3*/
    Map<String, dynamic>? result = await MethodChannel('com.ivehement.plugins/saf/documentfile')
                                          .invokeMapMethod<String, dynamic>('createFile', <String, dynamic>{
      'mimeType': 'any',
      'content': uint8list,
      'displayName': fileName,
      'directoryUri': '$uri',
    });
    print(result);
  }

  /*==================================
  ============= alert ================
  ==================================*/

  void _flutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Dialog Content",
                ),
              ],
            ),
            actions: <Widget>[
              FilledButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
            child: const Text('확인'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void numberPickerDialog(BuildContext context, paramNum, paramType) {
    var tempNum = int.parse(paramNum);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('번호 선택'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: <Widget>[
                NumberPicker(
                    value: tempNum,
                    minValue: 1,
                    maxValue: 45,
                    haptics: true,
                    onChanged: (value) {
                      setState(() => tempNum = value);// to change on widget level state
                    }
                ),
                Text('Current Number: $tempNum'),
              ],
            );
          },
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('취소'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인'),
            onPressed: () {
              if(paramType == 'min') {
                getMinNum.text = tempNum.toString();
              } else {
                getMaxNum.text = tempNum.toString();
              }

              setState(() {
                var numFormat = NumberFormat('###,###,###,###');
                GenNumber genNumber = GenNumber();

                rangePercent = numFormat.format(genNumber.calRate(int.parse(getMinNum.text), int.parse(getMaxNum.text)));
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  emptyContainer() {
    return Container(
      child: Text('Empty'),
    );
  }

  ballNoImage(index) {
    BallNumberImage bni = BallNumberImage();
    return SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(bni.getBallImageName(index))
    );
  }

}