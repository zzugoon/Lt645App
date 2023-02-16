import 'package:flutter/cupertino.dart';

class BallNumberImage {

  List<String> ballImageName = [
    'assets/image/lotteryNo_00.png'
    ,'assets/image/lotteryNo_01.png'
    ,'assets/image/lotteryNo_02.png'
    ,'assets/image/lotteryNo_03.png'
    ,'assets/image/lotteryNo_04.png'
    ,'assets/image/lotteryNo_05.png'
    ,'assets/image/lotteryNo_06.png'
    ,'assets/image/lotteryNo_07.png'
    ,'assets/image/lotteryNo_08.png'
    ,'assets/image/lotteryNo_09.png'
  ];

  String getBallImageName(index) {
    return ballImageName.elementAt(index);
  }

}