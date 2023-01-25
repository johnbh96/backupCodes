import 'package:flutter/material.dart';

import '../font.dart';

Color _localBorderColor = const Color(0xff1D1D1B);

class MainButton extends StatelessWidget {
  // Creates Button using theme from context or if given other sources provided else empty ButtonStyle and takes infinite horizontal space

  // use null for disabled state
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  // RoundedRectangleBorder is used as default for the button with this border
  // Shape is used instead of simple border due to states of a button(ref: MaterialState enum used as Set<MaterialState>)
  final MaterialStateProperty<OutlinedBorder?>? shape;
  const MainButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.borderColor,
    this.shape,
  })  : assert(
          borderColor == null || shape == null,
          'Cannot provide both a borderColor and a shape\n'
          'To provide both, use "shape: MaterialStateProperty.resolveWith((states) {return RoundedRectangleBorder()}".',
        ),
        super(key: key);

  factory MainButton.normal(
      {Key? key, required VoidCallback onPressed, required String text}) {
    return MainButton(
      onPressed: onPressed,
      text: text,
      color: _localBorderColor,
      textColor: Colors.white,
    );
  }

  factory MainButton.outlined(
      {Key? key, required VoidCallback onPressed, required String text}) {
    return MainButton(
      onPressed: onPressed,
      text: text,
      color: Colors.white,
      textColor: _localBorderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: (Theme.of(context).textButtonTheme.style ?? const ButtonStyle())
          .copyWith(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 18)),
        shape: shape ??
            MaterialStateProperty.resolveWith((states) {
              return RoundedRectangleBorder(
                  // double.infinity and double.maxPositive do not work here
                  borderRadius: BorderRadius.circular(10000),
                  side: states.contains(MaterialState.disabled)
                      ? BorderSide.none
                      : BorderSide(color: borderColor ?? _localBorderColor));
            }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color(0xffAFAFAF);
          }
          return color;
        }),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: Text(
            text,
            style: Theme.of(context).textTheme.button?.copyWith(
                fontSize: 14,
                fontFamily: SFProText,
                fontWeight: FontWeight.w500,
                color: textColor),
          ),
        ),
      ),
    );
  }
}
