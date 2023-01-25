import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../svg_util.dart';
import 'seat.dart';

var _availableSeats = SeatDetail('', SeatType.available, false, true);

class SeatSheet extends StatefulWidget {
  const SeatSheet({Key? key}) : super(key: key);
  // TODO: need to assert with data that a vehicle should at least have 3 columns
  @override
  State<SeatSheet> createState() => _SeatSheetState();
}

class _SeatSheetState extends State<SeatSheet> {
  var seat = _availableSeats.copywith(name: alphabeticalList[0]);
  late ValueNotifier<List<List<SeatDetail>>> data;

  // for test purposes generation is 4
  @override
  void initState() {
    data = ValueNotifier([
      List.generate(
          4,
          (index) => _availableSeats.copywith(
              name: '${alphabeticalList[index]}1',
              isEmpty: index == 0 || index == 3)),
      List.generate(
          4,
          (index) => _availableSeats.copywith(
              name: '${alphabeticalList[index]}2',
              seatType: SeatType.values[math.Random().nextInt(3)],
              isSelected: math.Random().nextBool())),
      List.generate(
          4,
          (index) => _availableSeats.copywith(
              name: '${alphabeticalList[index]}3',
              seatType: SeatType.values[math.Random().nextInt(3)],
              isSelected: math.Random().nextBool())),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xffEAEAEA),
      child: ValueListenableBuilder(
        valueListenable: data,
        builder: (context, List<List<SeatDetail>> x, child) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: x[0].length,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: x.length * x[0].length,
              itemBuilder: (context, index) {
                var column = index % 4;
                var row = (index / 4).floor();
                var seatData = x[row][column];
                // assuming that its at least 3 of length in a row
                //driver seat
                if (row == 0 && column == (x[0].length) - 1) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    child: driverIcon,
                  );
                }
                // Gap in front seat
                if (row == 0 && column == (x[0].length - 2)) {
                  return const Gap(1);
                }
                return Seat(
                  seatName: '${alphabeticalList[column]}${row + 1}',
                  isSelected: seatData.isSelected,
                  seatType: seatData.seatType,
                  size: const Size.square(40),
                  onTap: () {
                    var temp = x;
                    temp[row][column] =
                        seatData.copywith(isSelected: !(seatData.isSelected));
                    data.value = List.from(temp);
                  },
                );
              });
        },
      ),
    );
  }
}
