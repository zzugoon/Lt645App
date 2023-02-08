import 'dart:math';

import 'package:flutter/material.dart';

class GenNumber {
  dynamic genNum00;
  var genNum01;

  GenNumber();

  List<int> fn_genNumTypeA(no0, {no1, no2, no3}) {
    const int COUNT_NUM = 6;  // 생성할 번호 갯수
    
    List<int> result = [];// 리턴할 collection List
    int genRanNum;            // 번호 변수

    for(var i=0; i<COUNT_NUM; i++) {
      genRanNum = Random().nextInt(44);
      genRanNum = genRanNum+1;

      // print('indexOf :: ${result.indexOf(genRanNum)}');

      if(0 <= result.indexOf(genRanNum)) {
        i=i-1;
      }else{
        result.add(genRanNum);
      }
    }
    // print('정렬전 :: $result');
    result.sort();
    print('정렬후 :: $result');
    return result;
  }
}