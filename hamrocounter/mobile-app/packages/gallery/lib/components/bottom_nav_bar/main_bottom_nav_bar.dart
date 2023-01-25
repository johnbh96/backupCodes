import 'package:flutter/material.dart';
import 'package:gallery/components/bottom_nav_bar/nav_bar_icons.dart';
import 'package:gap/gap.dart';

class MainBottomNavBar extends StatefulWidget {
  final NavButton? activeButton;
  final VoidCallback? onChange;
  const MainBottomNavBar({Key? key, this.activeButton, this.onChange})
      : super(key: key);

  @override
  MainBottomNavBarState createState() => MainBottomNavBarState();
}

class MainBottomNavBarState extends State<MainBottomNavBar> {
  late ValueNotifier<NavButton> _value;

  @override
  void initState() {
    _value =
        ValueNotifier<NavButton>(widget.activeButton ?? NavButton.values[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white),
        child: ValueListenableBuilder<NavButton>(
          valueListenable: _value,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(NavButton.values.length, (index) {
                return Expanded(
                  child: InkWell(
                    borderRadius: _circularRadius(index),
                    onTap: () async {
                      if (_value.value != NavButton.values[index]) {
                        _value.value = NavButton.values[index];
                      }
                      widget.onChange;
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height * 0.12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: NavButton.values[index].getIcon),
                          value == NavButton.values[index]
                              ? Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Ink(
                                    height: 4,
                                    width: 4,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffB175BA)),
                                  ),
                                )
                              : const Gap(
                                  6,
                                  crossAxisExtent: 6,
                                )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ));
  }
}

BorderRadius? _circularRadius(index) {
  if (index == 0) {
    return const BorderRadius.only(topLeft: Radius.circular(20));
  } else if (index == NavButton.values.length - 1) {
    return const BorderRadius.only(topRight: Radius.circular(20));
  }
  return null;
}
