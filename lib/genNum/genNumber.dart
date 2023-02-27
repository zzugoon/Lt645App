import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenNumber {
  dynamic testDynamicNo;
  var testVarNo;

  List<Map> fn_genNumTypeA(int minNo, int maxNo, {keyNo1, keyNo2}) {
    const int COUNT_NUM = 6;  // 생성할 번호 갯수
    
    List<int> ranNumList = [];    // 리턴할 collection List
    List<Map> resultMap = [];
    int genRanNum;            // 생성된 번호 변수
    int keyNo;                // 생성할 번호 범위(max)

    keyNo = maxNo-minNo+1;

    for(var i=0; i<COUNT_NUM; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + minNo;

      if(0 <= ranNumList.indexOf(genRanNum)) {
        i=i-1;
      }else{
        ranNumList.add(genRanNum);
      }
    }
    ranNumList.sort();
    print('정렬후 :: $ranNumList');

    for(var i in ranNumList) {
      Map map = {};
      map['number'] = i.toString();

      if(i < 11) {
        map['color'] = 0xFFFFAB00;
      }else if(10<i && i<21){
        map['color'] = 0xFF0D47A1;
      }else if(20<i && i<31){
        map['color'] = 0xFFC62828;
      }else if(30<i  && i<41){
        map['color'] = 0xFF424242;
      }else if(40<i  && i<=45){
        map['color'] = 0xFF2E7D32;
      }

      resultMap.add(map);
    }
    print(resultMap);

    return resultMap;
  }

  double calRate(minNo, maxNo) {
    double result = 0;
    int childNo = 1;
    int? parentNo = 1;

    for(var i=0; i<6; i++) {
      childNo = (i!=0) ? childNo*(i+1) : 1;
      parentNo = (parentNo!*(maxNo-minNo-i+1)) as int?;
    }

    result = parentNo!/childNo;

    return result;
  }

  /*천단위 콤마*/
  thousands_separators(value){
    try{
      var numFormat = NumberFormat('###,###,###,###');
      return numFormat.format(value);
    }catch(e) {
      return 0;
    }
  }
}