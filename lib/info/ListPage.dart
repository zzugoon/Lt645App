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
              if(i==0 || numberList[i]['date'] != numberList[i-1]['date'])...[
                ListTile(
                  title: Text(numberList[i]['date']),
                  // subtitle: const Text('Tap here for Hero transition'),
                ),
              ],
              Container(
                margin: const EdgeInsets.all(5.0),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.black, width: 1),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx1'],),
                    ),
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx2'],),
                    ),
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx3'],),
                    ),
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx4'],),
                    ),
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx5'],),
                    ),
                    Container(width: 30,
                      alignment: Alignment.center,
                      child: Text(numberList[i]['idx6'],),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black, height: 2,),
            ]
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
}