import 'dart:async';
import 'dart:io';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../destination/destination.dart';

class ResultPage extends StatefulWidget {

  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  // final Destination destination;

  @override
  void initState() {
    super.initState();
    // if(Platform.isAndroid){
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }


  @override
  Widget build(BuildContext context) {
    const int itemCount = 50;
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      // foregroundColor: destination.color,
      fixedSize: const Size.fromHeight(128),
      textStyle: Theme.of(context).textTheme.headlineSmall,
    );
    return Scaffold(
      // backgroundColor: destination.color[50],
      // body: WebView(
      //   initialUrl: 'https://www.google.co.kr/',
      //   javascriptMode: JavascriptMode.unrestricted,
      //   onWebViewCreated: (WebViewController webViewController) {
      //     _controller.complete(webViewController);
      //   },
      // )
    );
  }
}