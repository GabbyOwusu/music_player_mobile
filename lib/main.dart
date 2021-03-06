import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/splash_screen.dart';
import 'package:music_streaming/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SongProvider>(
          create: (_) => SongProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Music streaming',
        theme: AppTheme.light,
        home: Splash(),
      ),
    );
  }
}
