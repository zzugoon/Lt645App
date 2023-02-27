import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../genNum/genNumber.dart';
import '../../home/RootPage.dart';

class HomeTabItem {

  late BuildContext context;

  var rangePercent = '1';

  TextEditingController getMinNum = TextEditingController(text: "1");
  TextEditingController getMaxNum = TextEditingController(text: "45");

  Widget tabItem() {
    return Container(
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
                  readOnly: true,
                  controller: getMinNum,
                  onTap: () => {
                    numberPickerDialog(context, getMinNum.text, 'min')
                  },
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                    labelStyle: TextStyle(fontFamily: "on_goelip", fontSize: 25, fontWeight: FontWeight.normal),
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
                  onTap: () => {
                    numberPickerDialog(context, getMaxNum.text, 'max')
                  },
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                    labelStyle: const TextStyle(
                        fontFamily: "on_goelip",
                        fontSize: 25,
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

              // setState(() {
              //   var numFormat = NumberFormat('###,###,###,###');
              //   GenNumber genNumber = GenNumber();
              //
              //   rangePercent = numFormat.format(genNumber.calRate(int.parse(getMinNum.text), int.parse(getMaxNum.text)));
              // });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}