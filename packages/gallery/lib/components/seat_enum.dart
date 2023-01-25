part of 'seat.dart';

enum SeatType { available, unavailable, disabled }

extension SeatExtension on SeatType {
  Color get toColor {
    switch (this) {
      case SeatType.available:
        return const Color(0xff1EAC00);
      case SeatType.disabled:
        return Colors.transparent;
      case SeatType.unavailable:
        return const Color(0xffFFD700);
    }
  }

  Widget toWidget(String seatName, {bool isSelected = false, void Function()? onTap}) {
    switch (this) {
      default:
        return Seat(
          isSelected: isSelected,
          seatName: seatName,
          borderRadius: 5,
          seatType: this,
          onTap: onTap,
        );
    }
  }

  Widget miniWiget(String seatName, {bool isSelected = false}) {
    switch (this) {
      default:
        return Seat(
          isSelected: isSelected,
          seatName: seatName,
          borderRadius: 5,
          seatType: this,
          size: const Size(27,27),
        );
    }
  }
}