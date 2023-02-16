import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lt645/model/BallNumberImage.dart';

import '../destination/destination.dart';
import '../genNum/genNumber.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  List<dynamic> numList = [['1번','2번','3번','4번','5번','6번']];
  dynamic rangePercent = '1';

  TextEditingController getMinNum = TextEditingController(text: "1");
  TextEditingController getMaxNum = TextEditingController(text: "45");

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.destination.title} AlertDialog'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
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
      appBar: AppBar(
        title: Text('Home - ${widget.destination.title}'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: widget.destination.color[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child:ElevatedButton(
                    child: const Text('번호 생성'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      minimumSize: Size(50, 50)
                    ),
                    onPressed: () {
                      if(numList.length >= 6) {
                        _cupertinoDialog(context);
                        return;
                      }
                      print('click~!!!');
                      setState(() {
                        // ==== "번호 생성하기 start" ====
                        var minNum = getMinNum.text;
                        var maxNum = getMaxNum.text;

                        GenNumber genNumber = GenNumber();
                        numList.add(genNumber.fn_genNumTypeA(
                            int.parse(minNum), int.parse(maxNum)
                            // keyNo1:int.parse("121"), keyNo2:int.parse("qqwe")
                        ));
                        // ===== "번호 생성하기 end" =====
                      });
                    },
                  ),
                ),
                sizeBox(10, 0),
                Flexible(
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      minimumSize: Size(50, 50)
                    ),
                    child: const Text('초기화'),
                    onPressed: () {
                      setState(() {
                        initData();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: null,
                    //   border: Border.all(color: Colors.blueGrey, width: 1),
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    // ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 10.0),
                    height: 30,
                    child: const Text("생성 범위",
                      style: TextStyle(
                        fontFamily: "on_goelip",
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                      )
                    ),
                  )
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.only(right: 10.0),
                    child: TextField(
                      controller: getMinNum,
                      onTapOutside: (value) {
                        setState(() {
                          var minNum = getMinNum.text;
                          var maxNum = getMaxNum.text;
                          var numFormat = NumberFormat('###,###,###,###');
                          GenNumber genNumber = GenNumber();

                          rangePercent = numFormat.format(genNumber.calRate(int.parse(minNum), int.parse(maxNum)));
                        });
                      },
                      onChanged: (value) {
                        print("value2 :: $value");
                      },
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        labelStyle: TextStyle(fontFamily: "on_goelip", fontSize: 20, fontWeight: FontWeight.normal),
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
                      controller: getMaxNum,
                      onChanged: (value) {
                      },
                      onTapOutside: (value) {
                        setState(() {
                          var minNum = getMinNum.text;
                          var maxNum = getMaxNum.text;
                          var numFormat = NumberFormat('###,###,###,###');
                          GenNumber genNumber = GenNumber();

                          rangePercent = numFormat.format(genNumber.calRate(int.parse(minNum), int.parse(maxNum)));
                        });
                      },
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        labelStyle: const TextStyle(
                            fontFamily: "on_goelip",
                            fontSize: 20,
                            fontWeight:
                            FontWeight.normal
                          ),
                        labelText: "최대값",
                      ),
                    ),
                  )
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 30,
                    child: const Text("당첨 확률 : ",
                        style: TextStyle(
                            fontFamily: "on_goelip",
                            fontSize: 20,
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
                        fontFamily: "on_goelip",
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                      )
                    ),
                  )
                ),
              ],
            ),
          ),
          sizeBox(0, 10),
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ballNoImage(1),
                ballNoImage(2),
                ballNoImage(3),
                ballNoImage(4),
                ballNoImage(5),
                ballNoImage(6),
              ],
            )
          ),
          listView(),
        ],
      )
    );
  }

  //wiget sizeBox
  sizeBox(width, heights) {
    return SizedBox(width: width ,height: heights);
  }

  //wiget ListView
  listView() {
    return Container(
      child: Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemCount: numList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 50,
                color: Colors.grey[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(numList[index][0].toString())
                    ),
                    Text(numList[index][1].toString()),
                    Text(numList[index][2].toString()),
                    Text(numList[index][3].toString()),
                    Text(numList[index][4].toString()),
                    Text(numList[index][5].toString()),
                  ],
                )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      )
    );
  }

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

  void _cupertinoDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('최대로 생성 가능한 번호는 5개 입니다.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // CupertinoDialogAction(
          //   isDestructiveAction: true,
          //   child: const Text('Yes'),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }

  initData() {
    numList = [['1번','2번','3번','4번','5번','6번']];
    getMinNum.text = "1";
    getMaxNum.text = "45";
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