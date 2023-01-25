import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../font.dart';
import 'date_departure_type.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _routeName(context, 'Kathmandu', 'Hetauda'),
            const Gap(10),
            _routePath(['Kulekhani', 'Pharping Road']),
            const Gap(10),
            _serviceCompany('Sikharapur Sumo Sewa Private Limited', 3.5),
            const Gap(10),
            DisplayDepartureType(
              date: DateTime.now(),
              type: 'Ac Sumo',
            ),
          ],
        ),
      ),
    );
  }

  _routeName(_, String from, String to) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          from,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: SFProText,
          ),
        ),
        const Icon(Icons.circle_outlined, size: 10),
        SizedBox(
          width: MediaQuery.of(_).size.width / 6,
          child: const DottedLine(),
        ),
        const Icon(Icons.circle, size: 10),
        Text(
          to,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: SFProText,
          ),
        )
      ],
    );
  }

  _routePath(List<String> paths) {
    return Text(
      paths.join(' - '),
      style: TextStyle(
          color: const Color(0xff555555), fontSize: 12, fontFamily: SFProText),
    );
  }

  _serviceCompany(String companyName, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          companyName,
          style: TextStyle(
            color: const Color(0xff242a36),
            fontSize: 16,
            fontFamily: SFProText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: const Color(0xff1EAC00),
              borderRadius: BorderRadius.circular(4)),
          child: Row(children: [
            const Icon(Icons.star, color: Colors.white, size: 10),
            const Gap(3),
            Text(
              rating.toString(),
              style: TextStyle(
                color: const Color(0xffffffff),
                fontSize: 12,
                fontFamily: SFProText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(3),
          ]),
        )
      ],
    );
  }
}
