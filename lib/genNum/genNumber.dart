import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenNumber {
  dynamic testDynamicNo;
  var testVarNo;

  List<int> fn_genNumTypeA(int minNo, int maxNo, {keyNo1, keyNo2}) {
    const int COUNT_NUM = 6;  // 생성할 번호 갯수
    
    List<int> result = [];    // 리턴할 collection List
    int genRanNum;            // 생성된 번호 변수
    int keyNo;                // 생성할 번호 범위(max)

    keyNo = maxNo-minNo+1;

    for(var i=0; i<COUNT_NUM; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + minNo;

      if(0 <= result.indexOf(genRanNum)) {
        i=i-1;
      }else{
        result.add(genRanNum);
      }
    }
    result.sort();
    print('정렬후 :: $result');
    return result;
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
    // print('minNo :: $minNo / maxNo :: $maxNo');
    // print('childNo :: $childNo / parentNo :: $parentNo');
    // print('result :: $result');

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