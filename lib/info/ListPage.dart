import 'dart:convert';
import 'dart:io';

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
          print(data); // data

          return data;
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
    setState(() {
      numberList = tempList!;
    });
  }

  @override
  void initState() {
    super.initState();

    numberList = [];
    setNumberList();
  }

  @override
  Widget build(BuildContext context) {
    const int itemCount = 20;
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
      body: SizedBox.expand(
        child: ListView(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: [
            for(var i=0; i < numberList.length; i++)...[
              Card(
                margin: EdgeInsets.all(5),
                shadowColor: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(numberList[i]['date']),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            numberRow(numberList[i]['idx1']),
                            numberRow(numberList[i]['idx2']),
                            numberRow(numberList[i]['idx3']),
                            numberRow(numberList[i]['idx4']),
                            numberRow(numberList[i]['idx5']),
                            numberRow(numberList[i]['idx6']),
                          ],
                        ),
                      ),                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {

                              },
                              child: Text('보기')
                          ),
                          TextButton(
                              onPressed: () {

                              },
                              child: Text('삭제')
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ]
            // for(var i=0; i < numberList.length; i++)...[
            //   if(i==0 || numberList[i]['date'] != numberList[i-1]['date'])...[
            //     ListTile(
            //       title: Text(numberList[i]['date']),
            //       // subtitle: const Text('Tap here for Hero transition'),
            //     ),
            //   ],
            //   Container(
            //     margin: const EdgeInsets.all(5.0),
            //     // decoration: BoxDecoration(
            //     //   border: Border.all(color: Colors.black, width: 1),
            //     // ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx1'],),
            //         ),
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx2'],),
            //         ),
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx3'],),
            //         ),
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx4'],),
            //         ),
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx5'],),
            //         ),
            //         Container(width: 30,
            //           alignment: Alignment.center,
            //           child: Text(numberList[i]['idx6'],),
            //         ),
            //       ],
            //     ),
            //   ),
            //   Divider(color: Colors.black, height: 2,),
            // ]
          ],
        ),

        //   ListView.builder(
        //   itemCount: itemCount,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        //       child: OutlinedButton(
        //         style: buttonStyle.copyWith(
        //           backgroundColor: MaterialStatePropertyAll<Color>(Color.lerp(
        //               destination.color[100],
        //               Colors.white,
        //               index / itemCount)!),
        //         ),
        //         onPressed: () {
        //           Navigator.pushNamed(context, '/text');
        //         },
        //         child: Text('Push /text [$index]'),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  Widget numberRow(numText) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // color: Color(numColor),
          shape: BoxShape.circle,
          // gradient: LinearGradient(
          //     colors: [Color(numColor).withOpacity(0.1), Color(numColor)],
          //     stops: [0.1, 0.6],
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft
          //
          // )
        // borderRadius: BorderRadius.circular(30)
      ),
      child: Text(numText,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: "wel_Regular",
            fontSize: 13,
            fontWeight: FontWeight.normal
        ),
      ),
    );
  }
}