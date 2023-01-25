import 'package:flutter/material.dart';
import 'package:gallery/components/bottom_nav_bar/main_bottom_nav_bar.dart';
import 'package:gallery/components/bottom_nav_bar/nav_bar_icons.dart';
import 'package:gallery/components/info_card/info_card.dart';
import 'package:gallery/components/info_sheet/info_sheet.dart';
import 'package:gallery/components/seats/seat_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blueGrey[900],
          elevation: 0,
        ),
        backgroundColor: const Color(0xffFFFF00),
        // bottomNavigationBar: const MainBottomNavBar(
        //   activeButton: NavButton.notification,
        // ),
        bottomNavigationBar: const InfoCard(),
        body: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF263238),
                        Color(0xFF263238),
                        Color(0xffEFEFEF),
                        Color(0xffEFEFEF),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.5, 0.5, 1.0])),
              width: double.infinity,
              child: const Center(child: InfoCard()),
            ),
            const SizedBox(height: 6),
            const Flexible(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SeatSheet(),
            ))
          ],
        ));
  }
}
