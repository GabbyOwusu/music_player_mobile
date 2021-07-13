import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';

class Mixes extends StatelessWidget {
  const Mixes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBAr(
        context,
        'Mixes',
        Icon(Icons.sort, color: Colors.black),
        backbutton(context),
      ),
    );
  }
}
