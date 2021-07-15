import 'package:flutter/material.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    Key key,
    @required this.tabs,
    @required this.currentIndex,
    @required this.index,
    @required this.ontapped,
  }) : super(key: key);

  final List<String> tabs;
  final int currentIndex;
  final int index;
  final VoidCallback ontapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontapped,
      child: Column(
        children: [
          Text(
            tabs[index],
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(height: 5),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}
