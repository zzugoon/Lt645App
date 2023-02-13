import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  dynamic rangePercent = '13';

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

  TextEditingController getMinNum = TextEditingController(text: "1");
  TextEditingController getMaxNum = TextEditingController(text: "45");

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
                        numList = [['1번','2번','3번','4번','5번','6번']];
                        getMinNum.text = "1";
                        getMaxNum.text = "45";
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
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 10.0),
                    height: 30,
                    child: Text("생성 범위"),
                  )
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.only(right: 10.0),
                    child: TextField(
                      controller: getMinNum,
                      onChanged: (value) {
                        print("value2 :: $value");
                      },
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
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
                        // GenNumber genNumber = GenNumber();
                        // genNumber.calRate(1, 45);
                      },
                      onTapOutside: (value) {
                        GenNumber genNumber = GenNumber();
                        genNumber.calRate(1, 45);
                      },
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        labelText: "최대값",
                      ),
                    ),
                  )
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text("당첨 확률"),
                  )
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(rangePercent),
                  )
                ),
              ],
            ),
          ),
          sizeBox(0, 10),
          listView(),
        ],
      )
    );
  }

  //wiget
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
                        color: Colors.lime,
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
}