library gallery;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../font.dart';

part 'seat_model.dart';

class Seat extends StatefulWidget {
  final String seatName;
  final double borderRadius;
  final Size size;
  final SeatType seatType;
  final BoxBorder? border;
  final bool isSelected;
  final void Function()? onTap;
  const Seat({
    Key? key,
    required this.seatName,
    required this.isSelected,
    this.border,
    this.borderRadius = 10,
    this.size = const Size(46, 46),
    this.seatType = SeatType.available,
    this.onTap,
  }) : super(key: key);

  @override
  SeatState createState() => SeatState();
}

class SeatState extends State<Seat> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: InkWell(
        radius: widget.borderRadius,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: widget.seatType == SeatType.available ? widget.onTap : null,
        child: widget.seatType == SeatType.nonSeat
            ? Gap(
                widget.size.height,
                crossAxisExtent: widget.size.width,
              )
            : Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: _buttonColor(widget.seatType, widget.isSelected),
                    border: widget.border),
                height: widget.size.height,
                width: widget.size.width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.size.height < 30 ? const Gap(1) : const Gap(6),
                      Text(
                        widget.seatName,
                        style: TextStyle(
                          color: _textColor(widget.seatType, widget.isSelected),
                          fontSize: 14,
                          fontFamily: SFProText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      widget.size.height < 30
                          ? const Gap(1)
                          : Ink(
                              height: 8,
                              width: widget.size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(90),
                                  topRight: Radius.circular(90),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Ink(
                                  width: widget.size.width - 4,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _typeColor(widget.seatType),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(90),
                                      topRight: Radius.circular(90),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _buttonColor(SeatType seatType, bool isSelected) {
    switch (seatType) {
      case SeatType.disabled:
        return const Color(0xffFBFBFB);
      case SeatType.available:
        if (isSelected) return const Color(0xffFF900C);
        return const Color(0xffFFFFFF);
      default:
        return const Color(0xffFFFFFF);
    }
  }

  _textColor(SeatType seatType, bool isSelected) {
    switch (seatType) {
      case SeatType.disabled:
        return const Color(0xffDDDDDD);
      case SeatType.available:
        if (isSelected) return const Color(0xffffffff);
        return const Color(0xff7C7C7C);
      default:
        return const Color(0xff7C7C7C);
    }
  }

  _typeColor(SeatType seatType) {
    switch (seatType) {
      case SeatType.available:
        return const Color(0xff1EAC00);
      case SeatType.disabled:
        return Colors.transparent;
      case SeatType.unavailable:
        return const Color(0xffFFD700);
      case SeatType.nonSeat:
        return null;
    }
  }
}
