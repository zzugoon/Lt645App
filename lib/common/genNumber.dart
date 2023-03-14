import 'dart:math';

import 'package:intl/intl.dart';

class CommonGenNumber {

  List<Map> fn_genNumTypeA(int minNo, int maxNo, {keyNo1, keyNo2}) {
    const int CREATE_NUMBER = 6;  // 생성할 번호 갯수
    
    int genRanNum;                // 생성된 번호 변수
    int keyNo;                    // 생성할 번호 범위(max)
    List<int> ranNumList = [];
    List<Map> resultMap = [];     // 리턴할 collection List

    keyNo = maxNo-minNo+1;

    for(var i=0; i<CREATE_NUMBER; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + minNo;

      if(ranNumList.contains(genRanNum)) {
        i=i-1;
      }else{
        ranNumList.add(genRanNum);
      }
    }
    ranNumList.sort();
    resultMap = setNumColor(ranNumList);

    return resultMap;
  }

  List<Map> fn_genNumTypeB(List listParam) {
    int createNumber = 6 - listParam.length; // 생성할 번호 갯수
    int keyNo = 45;                          // 생성할 번호 범위(max)
    int genRanNum;                           // 생성된 번호 변수

    List<int> ranNumList = [...listParam];
    List<Map> resultMap = [];                // 리턴할 collection List


    for(var i=0; i<createNumber; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + 1;
      if(ranNumList.contains(genRanNum)) {
        i=i-1;
      }else{
        ranNumList.add(genRanNum);
      }
    }
    ranNumList.sort();
    resultMap = setNumColor(ranNumList);

    return resultMap;
  }

  List<Map> fn_genNumTypeC(List listParam) {
    const int CREATE_NUMBER = 6;  // 생성할 번호 갯수
    int keyNo = 45;               // 생성할 번호 범위(max)
    List banList = listParam;     // 생성하지 않는 번호 리스트

    List<int> ranNumList = [];
    List<Map> resultMap = [];     // collection List
    int genRanNum;                // 생성된 번호 변수


    for(var i=0; i<CREATE_NUMBER; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + 1;
      // print('genRanNum :: $genRanNum');
      if(ranNumList.contains(genRanNum) || banList.contains(genRanNum)) {
        i=i-1;
      }else{
        ranNumList.add(genRanNum);
      }
    }
    ranNumList.sort();
    resultMap = setNumColor(ranNumList);

    return resultMap;
  }

  List<Map> fn_genNumTypeD(List listParam) {
    const int CREATE_NUMBER = 6;  // 생성할 번호 갯수
    int keyNo = 45;               // 생성할 번호 범위(max)
    int genRanNum;                // 생성된 번호 변수

    List banList = [];            // 생성하지 않는 번호 리스트
    List<int> ranNumList = [];
    List<Map> resultMap = [];     // collection List

    for(var i=0; i<listParam.length-1; i++) {
      if(!listParam[i]) {
        for(var j=1; j<=10; j++) {
          if(i<4) {
            banList.add(i*10+j);
          }else{
            if(j<6) {
              banList.add(i*10+j);
            }
          }
        }
      }
    }

    for(var i=0; i<CREATE_NUMBER; i++) {
      genRanNum = Random().nextInt(keyNo);
      genRanNum = genRanNum + 1;

      if(0 <= ranNumList.indexOf(genRanNum) || 0 <= banList.indexOf(genRanNum)) {
        i=i-1;
      }else{
        ranNumList.add(genRanNum);
      }
    }
    ranNumList.sort();
    resultMap = setNumColor(ranNumList);

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
  
  List<Map> setNumColor(numberList) {
    List<Map> resultMap = [];
    for(var i in numberList) {
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
    
    return resultMap;
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