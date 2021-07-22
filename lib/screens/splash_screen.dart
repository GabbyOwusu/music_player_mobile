import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/welcome.dart';
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

  SongProvider get p {
    return Provider.of<SongProvider>(context, listen: false);
  }

  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        setState(() => visible = true);
        Future.delayed(
          Duration(seconds: 3),
          () {
            setState(() {});
            // checkFirstSeen();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Welcome();
                },
              ),
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    p.initQuery();
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        opacity: visible ? 1 : 0,
        child: Center(
          child: Text(
            'Hi there,',
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
