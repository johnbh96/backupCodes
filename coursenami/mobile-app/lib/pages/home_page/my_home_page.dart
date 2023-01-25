import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../go_router_helper/routes.dart';
import '../../widgets/export.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width - 40;
    return SafeArea(
      top: true,
      child: Scaffold(
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 6,
              width: MediaQuery.of(context).size.width,
              child: const DashedLine(
                  height: 6,
                  indent: 0,
                  endIndent: 2,
                  dashSpace: 6,
                  dashWidth: 29,
                  color: Color(0xff19ACAC)),
            ),
          ),
          questionBar(),
          const SizedBox(height: 10),
          // big blank coloured space
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffffe2cf),
                width: 1,
              ),
              color: const Color(0x19ee5f01),
            ),
          ),
          questionDetails(widthScreen)
        ]),
        bottomSheet: Container(
          width: widthScreen + 40,
          padding: const EdgeInsets.only(bottom:10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            border: Border.all(
              color: const Color(0xadd7d4d4),
              width: 1,
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 70,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(151, 151, 151, 1),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Swipe up for answer',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(41, 41, 41, 1),
                    fontFamily: 'Product Sans',
                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          child: const Text(
                            'NEXT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Product Sans',
                                fontSize: 14,
                                letterSpacing: 0),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xff19ACAC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.share_outlined,
                        color: Color(0xff475467),
                        size: 32,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.bookmark_border_outlined,
                          color: Color(0xff475467),
                          size: 32,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget questionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: <Widget>[
        Expanded(
          child: Row(children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff73bfea),
              ),
              alignment: Alignment.center,
              child: const Text(
                '2:30',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'Old Question 2072',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Set A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ]),
        ),
        const SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            Icons.more_horiz_sharp,
            color: Color(0xff475467),
            size: 32,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        const SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              color: Color(0xff475467),
              size: 32,
            )),
      ]),
    );
  }

  Widget questionDetails(double widthScreen) {
    return Column(
      children: <Widget>[
        Container(
          width: widthScreen,
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Question 5',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: widthScreen,
                child: const Text(
                  'What is the rate law of reaction? How does order of a reaction differ from molecularity of a reaction?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0x3321ab0a),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 2,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Important',
                        style: TextStyle(
                          color: Color(0xff21ab0a),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(
                      child: Text(
                        '4 Marks',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xff757575),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
