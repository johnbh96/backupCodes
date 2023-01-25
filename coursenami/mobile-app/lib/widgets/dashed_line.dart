import 'dart:ui';

import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double height;

  final double indent;

  final double endIndent;

  final Color color;

  final double dashWidth;

  final double dashSpace;

  /// Creates a material design dashedLine divider.
  ///
  /// The [height], [thickness], [indent], and [endIndent] must be null or
  /// non-negative.
  const DashedLine({
    Key? key,
    required this.height,
    this.dashWidth = 1,
    this.dashSpace = 1,
    required this.indent,
    required this.endIndent,
    required this.color,
  })  : assert(height >= 0.0),
        assert(dashWidth >= 0.0),
        assert(indent >= 0.0),
        assert(endIndent >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
        child: CustomPaint(
          painter: DashedLinePainter(
            color,
            height,
            dashWidth: dashWidth,
            dashSpace: dashSpace,
          ),
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashWidth;
  final double dashSpace;
  final bool isBox;

  DashedLinePainter(
    this.color,
    this.thickness, {
    this.isBox = false,
    this.dashWidth = 1,
    this.dashSpace = 1,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (isBox) {
      final Paint paint = Paint()
        ..strokeWidth = dashWidth
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final Path path = Path()
        ..addRect(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
        );
      final Path dashedpath = dashPath(
        path,
        const DashOffset.absolute(0.0),
        // ignore: always_specify_types
        dashArray: CircularIntervalList(const <double>[2, 4])
      );
      canvas.drawPath(dashedpath, paint);
    } else {
      final Paint paint = Paint()
        ..color = color
        ..strokeWidth = thickness;
      for (double startX = 0;
          startX < size.width;
          startX += dashWidth + dashSpace) {
        canvas.drawLine(
            Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path dashPath(
  Path source,
  DashOffset dashOffset,{
  required CircularIntervalList<double> dashArray,
}) {

  // TODO: Is there some way to determine how much of a path would be visible today?
  final Path dest = Path();
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = dashOffset._calculate(metric.length);
    bool draw = true;
    while (distance < metric.length) {
      final double len = dashArray.next;
      if (draw) {
        dest.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
      }
      distance += len;
      draw = !draw;
    }
  }

  return dest;
}

class CircularIntervalList<T> {
  CircularIntervalList(this._vals);

  final List<T> _vals;
  int _idx = 0;

  T get next {
    if (_idx >= _vals.length) {
      _idx = 0;
    }
    return _vals[_idx++];
  }
}

// ignore: constant_identifier_names
enum _DashOffsetType { Absolute, Percentage }

class DashOffset {
  /// Create a DashOffset that will be measured as a percentage of the length
  /// of the segment being dashed.
  ///
  /// `percentage` will be clamped between 0.0 and 1.0; null will be converted
  /// to 0.0.
  DashOffset.percentage(double percentage)
      : _rawVal = percentage.clamp(0.0, 1.0),
        _dashOffsetType = _DashOffsetType.Percentage;

  /// Create a DashOffset that will be measured in terms of absolute pixels
  /// along the length of a [Path] segment.
  ///
  /// `start` will be coerced to 0.0 if null.
  const DashOffset.absolute(double start)
      : _rawVal = start,
        _dashOffsetType = _DashOffsetType.Absolute;

  final double _rawVal;
  final _DashOffsetType _dashOffsetType;

  double _calculate(double length) {
    return _dashOffsetType == _DashOffsetType.Absolute
        ? _rawVal
        : length * _rawVal;
  }
}
