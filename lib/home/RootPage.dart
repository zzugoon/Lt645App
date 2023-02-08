import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/destination.dart';
import '../genNum/genNumber.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  List<dynamic> rsl = [[1,3,5,2,4,6]];

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.destination.title} AlertDialog'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineSmall = Theme.of(context).textTheme.headlineSmall!;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.destination.color,
      visualDensity: VisualDensity.comfortable,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      textStyle: headlineSmall,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home - ${widget.destination.title}'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    print('click~!!!');
                    setState(() {
                      // ===== "번호 생성하기 end" =====
                      GenNumber genNumber = GenNumber();
                      rsl.add(genNumber.fn_genNumTypeA("0번이오"));
                      // ==== "번호 생성하기 start" ====
                    });
                  },
                  child: const Text('Generate Number_test')
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: rsl.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.orange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(rsl[index][0].toString()),
                      Text(rsl[index][1].toString()),
                      Text(rsl[index][2].toString()),
                      Text(rsl[index][3].toString()),
                      Text(rsl[index][4].toString()),
                      Text(rsl[index][5].toString()),
                    ],
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          )
        ],
      )
    );
  }
}