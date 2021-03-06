import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/index.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool visible = false;
  bool firstRun = false;

  // Future checkFirstSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool _seen = (prefs.getBool('seen') ?? false);

  //   if (_seen) {
  //     print('App has already been run $_seen');
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return Home();
  //         },
  //       ),
  //     );
  //   } else {
  //     print('First time running TRUE');
  //     await prefs.setBool('seen', true);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return Welcome();
  //         },
  //       ),
  //     );
  //   }
  // }

  void _navigate() async {
    final p = context.read<SongProvider>();
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => visible = true);
    await Future.delayed(Duration(seconds: 3));
    await p.initQuery();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Index();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        opacity: visible ? 1 : 0,
        child: Center(
          child: Text(
            'Hi there',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
