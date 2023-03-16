import 'dart:convert';
import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../destination/destination.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  late List numberList;
  late List<Widget> numberList2;

  late List insSheetNumList;

  @override
  void initState() {
    super.initState();

    numberList = [];
    numberList2 = [];
    insSheetNumList = [];

    setNumberList();
    setSheetNumList();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      // foregroundColor: destination.color,
      fixedSize: const Size.fromHeight(128),
      textStyle: Theme.of(context).textTheme.headlineSmall,
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${destination.title} ListPage - /list'),
      // ),
      // backgroundColor: destination.color[50],
      body: LayoutBuilder(builder: (context, constraint) {
        return Swiper(
          loop: false,
          // layout: SwiperLayout.STACK,
          pagination: const SwiperPagination(alignment: Alignment.bottomRight,
            builder: SwiperPagination.dots,
          ),
          itemCount: numberList2.length,
          itemBuilder: (BuildContext context, int index){
            return numberList2[index];
          },
          index: 1,
          scale: 0.9,
          viewportFraction: 0.9,
          itemWidth: constraint.biggest.width*0.8,
          itemHeight: constraint.biggest.height*0.8,
          control: const SwiperControl(
            iconNext: Icons.arrow_forward_ios,
            iconPrevious: Icons.arrow_back_ios_new_sharp,
            color: Colors.black45,
          ),
        );
      })
    );
  }

  //=== 파일 불러오기 ===
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    return File('$path/data.json');
  }

  Future<List?> loadData() async {
    try {
      // 파일 읽기.
      final file = await _localFile;

      if (await file.exists()) {
        final jsonString = await file.readAsString();

        if(jsonString != null || jsonString != 'null') {
          List<dynamic> data = jsonDecode(jsonString);

          List listData = [];
          List tempData = [];

          for(var i=0; i<data.length; i++){
            if(i==0 || data[i]['date'] == data[i-1]['date']) {
              tempData.add(data[i]);
            } else {
              listData.add(tempData);
              tempData = [];
              tempData.add(data[i]);
            }
          }
          listData.add(tempData);

          return listData;
        }
      }
    } catch (e) {
      // 에러가 발생할 경우 0을 반환.
      return null;
    }
    return null;
  }

  setNumberList() async {
    List<dynamic>? tempList = await loadData();
    numberList = tempList!;

    setState(() {
      numberList2 = createSwipeList(numberList);
      print(numberList2);
    });
  }

  setSheetNumList() {
    List resultList = [];
    List<int> tempList = [];

    for(var i=1; i<50; i++) {
      tempList.add(i);
      if(i%7 == 0 && i<50) {
        resultList.add(tempList);
        tempList = [];
      }
    }
    insSheetNumList = resultList;
  }

  List<Widget> createSwipeList(numberList) {
    List<Widget> resultList = [];
    late Widget? tempWidget;
    
    for(var j=0; j<numberList.length; j++) {
      tempWidget =
        SizedBox.expand(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
            shrinkWrap: true,
            itemCount: numberList[j].length,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.grey,
                // margin: EdgeInsets.only(left: 5,right: 5 ,top: 5, bottom: 5),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0, bottom: 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, left: 5.0),
                        child: Text(numberList[j][index]['date']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            numberRow(numberList[j][index]['idx1'], numberList[j][index]['color1']),
                            numberRow(numberList[j][index]['idx2'], numberList[j][index]['color2']),
                            numberRow(numberList[j][index]['idx3'], numberList[j][index]['color3']),
                            numberRow(numberList[j][index]['idx4'], numberList[j][index]['color4']),
                            numberRow(numberList[j][index]['idx5'], numberList[j][index]['color5']),
                            numberRow(numberList[j][index]['idx6'], numberList[j][index]['color6']),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              showFlexibleBottomSheet(
                                draggableScrollableController: DraggableScrollableController(),
                                bottomSheetColor: Colors.white,
                                minHeight: 0,
                                initHeight: 0.8,
                                maxHeight: 0.8,
                                context: context,
                                builder: (BuildContext context,
                                  ScrollController scrollController,
                                  double bottomSheetOffset) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.45,
                                    child: Container(
                                        color: Colors.cyanAccent,
                                        margin: EdgeInsets.all(20.0),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 10.0),
                                              child: Text('번호선택 작성 표'),
                                            ),
                                            for(var i=0; i<insSheetNumList.length; i++)...[
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              createSheetRow(insSheetNumList[i], numberList[j][index]),
                                            ]
                                          ],
                                        )
                                    ),
                                  );
                                },
                                isExpand: false,
                              );
                            },
                            child: const Text('보기')
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        );

      resultList.add(tempWidget);
      tempWidget = null;
    }
    
    return resultList; 
  }

  /*Widget _buildBottomSheet(
      BuildContext context, ScrollController scrollController, double bottomSheetOffset) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Container(
          color: Colors.cyanAccent,
          margin: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text('번호선택 작성 표'),
              ),
              for(var i=0; i<insSheetNumList.length; i++)...[
                const SizedBox(
                  height: 5.0,
                ),
                createSheetRow(insSheetNumList[i]),
              ]
            ],
          )
        ),
      );
  }*/

  createSheetRow(paramList, paramMap) {
    List tempList = [];
    for(var i=1; i<=6; i++) {
      tempList.add(paramMap['idx$i']);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for(var i=0; i<paramList.length; i++)
          if(paramList[i] < 46)...[
            createSheetRowText(paramList[i], tempList)
          ]else...[
            Container(width: 28, height: 28,)
          ]
      ],
    );
  }

  createSheetRowText(param, List numList) {
    var numParam = numList.contains(param.toString());
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          shape: BoxShape.rectangle,
          color: numParam ? Colors.black54 : null,
          // You can use like this way or like the below line
          //borderRadius: new BorderRadius.circular(30.0),
          // color: changePartialColor(idx, listIndex, selections)
      ),
      alignment: Alignment.center,
      child: Text((param).toString(),
      //   style: TextStyle(
      //     color: selections[idx][listIndex] ? Colors.white : Colors.black38,
      //   ),
      ),
    );
  }


  Widget numberRow(numText, numColor) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(numColor),
          // shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [Color(numColor).withOpacity(0.1), Color(numColor)],
              stops: [0.1, 0.6],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft

          ),
          borderRadius: BorderRadius.circular(30)
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
}