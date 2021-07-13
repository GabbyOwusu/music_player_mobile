import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/screens/mixes.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Recently played',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 180,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(0, 30),
                blurRadius: 30,
                spreadRadius: -15,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text('45mins'),
              ),
              Spacer(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Burna boy,Joey B',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Level up',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  playArrow,
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              Text(
                'Mixes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Mixes();
                  }));
                },
                child: Image.asset(
                  'images/arrow.png',
                  width: 20,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 180,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return index == 0
                  ? Container(
                      width: 150,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 30 : 20,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.music_note),
                    )
                  : Container(
                      width: 150,
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 30 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: playArrow,
                    );
            },
          ),
        )
      ],
    );
  }
}
