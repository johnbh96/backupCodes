part of 'seat.dart';

enum SeatType { available, unavailable, disabled, nonSeat }

extension SeatExtension on SeatType {

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

class SeatDetail {
  final String name;
  final SeatType seatType;
  final bool isSelected;
  final bool isEmpty;

  SeatDetail(this.name, this.seatType, this.isSelected, this.isEmpty);

  SeatDetail copywith({String? name, SeatType? seatType, bool? isSelected, bool? isEmpty}){
    return SeatDetail(
      name ?? this.name,
      seatType ?? this.seatType,
      isSelected ?? this.isSelected,
      isEmpty ?? this.isEmpty
    );
  }
}

var alphabeticalList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
