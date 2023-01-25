import 'package:flutter/material.dart';
import 'package:gallery/date_util.dart';
import 'package:gap/gap.dart';

import '../font.dart';

class DisplayDepartureType extends StatelessWidget {
  final DateTime date;
  final String type;
  const DisplayDepartureType({Key? key, required this.date, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _singleColumn('Date', date.toString().split(' ').first),
        _singleColumn('Departure Time', date.toTime),
        _singleColumn('Type', 'AC Sumo')
      ],
    );
  }

  Widget _singleColumn(String name, String value) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            color: const Color(0xffFF900C),
            fontSize: 12,
            fontFamily: SFProText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xff404040),
            fontSize: 14,
            fontFamily: SFProText,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
