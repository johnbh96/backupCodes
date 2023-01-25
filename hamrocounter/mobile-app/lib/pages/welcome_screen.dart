import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding/onboarding_cubit.dart';

int _noOfPages = 3;

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin{
  late TabController _controller;
  ValueNotifier<int> page = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: _noOfPages,
      vsync: this
    );
    _controller.addListener(() {
      page.value = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: TabBarView(
                controller: _controller,
                  children: List<Widget>.generate(
                      _noOfPages,
                      (int index) => Container(
                            color: Colors.primaries[index],
                          )))),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.grey,
                        height: 2,
                        child: TabBar(
                          indicatorColor: Colors.black,
                          controller: _controller,
                            tabs: List<Widget>.generate(
                                _noOfPages,
                                (int index) => const SizedBox())),
                      )),
                  const Expanded(flex: 3, child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<int>(
                      valueListenable: page,
                      builder: (BuildContext context, int value, Widget? child) {
                        return Container(
                          alignment: Alignment.centerRight,
                          child: onBoardingButton(
                            context,
                            isSkip: value != (_noOfPages - 1)
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget onBoardingButton(BuildContext _, {bool isSkip = true}) {
    return TextButton(
      onPressed: () => _.read<OnBoardingCubit>().skip(_),
      child: Text(
        isSkip ? 'Skip' : 'Get Started',
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 57, 58, 58),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // <-- Radius
        ),
      ),
    );
  }
}
