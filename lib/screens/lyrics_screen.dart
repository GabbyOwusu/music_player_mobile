import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class Lyrics extends StatefulWidget {
  const Lyrics({Key? key}) : super(key: key);

  @override
  _LyricsState createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playing = p.playing;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50),
        physics: BouncingScrollPhysics(),
        controller: ModalScrollController.of(context),
        child: Column(
          children: [
            Text(
              playing?.album ?? 'Unknown',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5),
            Text(
              playing?.title ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Magna ipsum irure ea aliqua. Adipisicing culpa exercitation laboris nulla nulla. Do elit exercitation magna qui ea sunt anim aliqua cupidatat incididunt commodo aliquip ut laborum. Est do deserunt dolor veniam ipsum aute aliquip sit ea irure ullamco consectetur dolor. Duis magna exercitation amet esse Lorem velit id occaecat nostrud. Incididunt sint enim ullamco ea. Magna ipsum irure ea aliqua. Adipisicing culpa exercitation laboris nulla nulla. Do elit exercitation magna qui ea sunt anim aliqua cupidatat incididunt commodo aliquip ut laborum. Est do deserunt dolor veniam ipsum aute aliquip sit ea irure ullamco consectetur dolor. Duis magna exercitation amet esse Lorem velit id occaecat nostrud. Incididunt sint enim ullamco ea. Magna ipsum irure ea aliqua. Adipisicing culpa exercitation laboris nulla nulla. Do elit exercitation magna qui ea sunt anim aliqua cupidatat incididunt commodo aliquip ut laborum. Est do deserunt dolor veniam ipsum aute aliquip sit ea irure ullamco consectetur dolor. Duis magna exercitation amet esse Lorem velit id occaecat nostrud. Incididunt sint enim ullamco ea.Magna ipsum irure ea aliqua. Adipisicing culpa exercitation laboris nulla nulla. Do elit exercitation magna qui ea sunt anim aliqua cupidatat incididunt commodo aliquip ut laborum. Est do deserunt dolor veniam ipsum aute aliquip sit ea irure ullamco consectetur dolor. Duis magna exercitation amet esse Lorem velit id occaecat nostrud. Incididunt sint enim ullamco ea.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
