import 'package:flutter/material.dart';
import 'package:gallery/components/button/main_button.dart';
import 'package:gallery/components/font.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({Key? key}) : super(key: key);
  // ValueNotifier<List<String>> update = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 9,
              offset: Offset(0, -2),
            ),
          ],
          color: Colors.white,
          backgroundBlendMode: BlendMode.srcOut),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffFF900C).withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _checkoutDetail()),
            Expanded(child: _nextButton(context))
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return const MainButton(
        // onPressed: () {},
        color: Color(0xffff900c),
        textColor: Colors.white,
        text: 'Next');
  }

  Widget _checkoutDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Total Price",
          style: TextStyle(
            color: const Color(0xff404040),
            fontSize: 12,
            fontFamily: SFProText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Rs. 1400",
          style: TextStyle(
            color: const Color(0xffff900c),
            fontSize: 18,
            fontFamily: SFProText,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Seats: 1 | A1  ",
          style: TextStyle(
            fontFamily: SFProText,
            color: const Color(0xff404040),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
