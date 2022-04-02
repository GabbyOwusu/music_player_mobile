import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/constants.dart';
import 'package:music_streaming/constants/ui_colors.dart';

class CoverArt extends StatelessWidget {
  final Uint8List? art;
  final double? size;
  final BorderRadius? radius;
  const CoverArt({
    Key? key,
    required this.art,
    this.size,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return art != null
        ? ClipRRect(
            borderRadius: radius ?? BorderRadius.circular(20),
            child: Image.memory(
              art!,
              width: double.infinity,
              height: double.infinity,
              scale: 1.0,
              fit: BoxFit.cover,
            ),
          )
        : IconButton(
            onPressed: null,
            icon: Image.asset(
              Constants.IMG_DISK,
              color: UiColors.blue,
              height: size ?? 50,
            ),
          );
  }
}
