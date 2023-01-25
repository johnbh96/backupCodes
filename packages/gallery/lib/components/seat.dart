library gallery;
import 'package:flutter/material.dart';

part 'seat_enum.dart';

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
  // ignore: library_private_types_in_public_api
  _SeatState createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            decoration: BoxDecoration(
                color: widget.seatType == SeatType.disabled
                    ? const Color(0xffFBFBFB)
                    : widget.isSelected && widget.seatType == SeatType.available
                        ? const Color(0xffFF900C)
                        : const Color(0xffFFFFFF),
                border: widget.border),
            alignment: Alignment.bottomCenter,
            height: widget.size.height,
            width: widget.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.size.height < 30 ? const SizedBox(): const SizedBox(height:6),
                Text(
                  widget.seatName,
                  style:  TextStyle(
                    color: widget.seatType == SeatType.disabled
                      ? const Color(0xffDDDDDD)
                      : widget.isSelected && widget.seatType == SeatType.available
                          ? const Color(0xffffffff)
                          : const  Color(0xff7C7C7C),
                    fontSize: 14,
                    fontFamily: "SF Pro Text",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                widget.size.height < 30
                    ? const SizedBox()
                    : Container(
                      height: 8,
                      width: widget.size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(90),
                          topRight: Radius.circular(90)
                        )
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: widget.size.width - 4,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.seatType.toColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(90),
                            topRight: Radius.circular(90)
                          )
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
}
