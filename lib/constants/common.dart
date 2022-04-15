import 'package:flutter/material.dart';

String twoDigits(int? n) {
  return (n ?? 00).toString().padLeft(2, "0");
}

class CustomForm extends StatelessWidget {
  final String? hint;
  final Function(String)? onchange;
  const CustomForm({
    Key? key,
    this.hint,
    this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchange,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15),
        fillColor: Colors.grey[100],
        filled: true,
      ),
    );
  }
}

String parseDuration(int ms) {
  String data;
  Duration duration = Duration(milliseconds: ms);
  bool hasHours = duration.inHours > 0;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  final hours = duration.inHours.remainder(60);
  data =
      "${hasHours ? "${twoDigits(hours)}:" : ""}${twoDigits(minutes)}:${twoDigits(seconds)}";
  return data;
}

Widget playArrow = Image.asset(
  'images/play.png',
  width: 25,
  color: Colors.white,
);

Widget backbutton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    icon: Icon(Icons.arrow_back),
    color: Colors.black,
  );
}

class CustomField extends StatelessWidget {
  final Function(String)? onchange;

  const CustomField({
    Key? key,
    this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 10),
      child: TextField(
        onChanged: onchange,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          disabledBorder: InputBorder.none,
          filled: true,
          isDense: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ),
    );
  }
}

class SquircleBorder extends ShapeBorder {
  final BorderSide side;
  final BorderRadius? radius;

  const SquircleBorder({
    this.side: BorderSide.none,
    this.radius,
  });

  const SquircleBorder.only({
    this.side: BorderSide.none,
    this.radius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  SquircleBorder none() => const SquircleBorder(radius: BorderRadius.zero);

  @override
  ShapeBorder scale(double t) {
    return SquircleBorder(
      side: side.scale(t),
      radius: radius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect.deflate(side.width), radius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect, radius);
  }

  static Path _squirclePath(Rect rect, BorderRadius? radius) {
    final c = rect.center;
    double startX = rect.left;
    double endX = rect.right;
    double startY = rect.top;
    double endY = rect.bottom;

    double midX = c.dx;
    double midY = c.dy;

    if (radius == null) {
      return Path()
        ..moveTo(startX, midY)
        ..cubicTo(startX, startY, startX, startY, midX, startY)
        ..cubicTo(endX, startY, endX, startY, endX, midY)
        ..cubicTo(endX, endY, endX, endY, midX, endY)
        ..cubicTo(startX, endY, startX, endY, startX, midY)
        ..close();
    }

    return Path()

      // Start position
      ..moveTo(startX, startY + radius.topLeft.y)

      // top left corner
      ..cubicTo(
        startX,
        startY,
        startX,
        startY,
        startX + radius.topLeft.x,
        startY,
      )

      // top line
      ..lineTo(endX - radius.topRight.x, startY)

      // top right corner
      ..cubicTo(
        endX,
        startY,
        endX,
        startY,
        endX,
        startY + radius.topRight.y,
      )

      // right line
      ..lineTo(endX, endY - radius.bottomRight.y)

      // bottom right corner
      ..cubicTo(
        endX,
        endY,
        endX,
        endY,
        endX - radius.bottomRight.x,
        endY,
      )

      // bottom line
      ..lineTo(startX + radius.bottomLeft.x, endY)

      // bottom left corner
      ..cubicTo(
        startX,
        endY,
        startX,
        endY,
        startX,
        endY - radius.bottomLeft.y,
      )
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        var path = getOuterPath(rect.deflate(side.width / 2.0),
            textDirection: textDirection);
        canvas.drawPath(path, side.toPaint());
    }
  }
}
