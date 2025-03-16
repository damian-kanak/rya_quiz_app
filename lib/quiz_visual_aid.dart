import 'package:flutter/material.dart';
import 'dart:math' as math;

class QuizVisualAid extends StatefulWidget {
  final String type;
  final String data;
  final double size;

  const QuizVisualAid({
    super.key,
    required this.type,
    required this.data,
    this.size = 200,
  });

  @override
  State<QuizVisualAid> createState() => _QuizVisualAidState();
}

class _QuizVisualAidState extends State<QuizVisualAid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _hoveredPoint;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (details) {
              if (widget.type == 'points_of_sail' || widget.type == 'navigation') {
                setState(() {
                  _rotation += details.delta.dx * 0.01;
                });
              }
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                switch (widget.type) {
                  case 'points_of_sail':
                    return _buildPointsOfSailDiagram();
                  case 'wind_direction':
                    return _buildWindDirectionDiagram();
                  case 'tide_cycle':
                    return _buildTideCycleDiagram();
                  case 'navigation':
                    return _buildNavigationDiagram();
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsOfSailDiagram() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: PointsOfSailPainter(
            rotation: _rotation,
            hoveredPoint: _hoveredPoint,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) {
              final center = Offset(widget.size / 2, widget.size / 2);
              final position = details.localPosition;
              final angle = math.atan2(
                position.dy - center.dy,
                position.dx - center.dx,
              ) * 180 / math.pi;
              
              // Determine which point of sail was tapped
              final points = [
                {'text': 'Close Hauled', 'angle': 45.0},
                {'text': 'Close Reach', 'angle': 67.5},
                {'text': 'Beam Reach', 'angle': 90.0},
                {'text': 'Broad Reach', 'angle': 135.0},
                {'text': 'Running', 'angle': 180.0},
              ];

              for (var point in points) {
                final pointAngle = point['angle'] as double;
                if ((angle - pointAngle).abs() < 20) {
                  setState(() {
                    _hoveredPoint = point['text'] as String;
                  });
                  break;
                }
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWindDirectionDiagram() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: WindDirectionPainter(
            animation: _animation.value,
            hoveredPoint: _hoveredPoint,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) {
              final center = Offset(widget.size / 2, widget.size / 2);
              final position = details.localPosition;
              
              // Determine which wind vector was tapped
              if ((position.dy - center.dy).abs() < 20) {
                setState(() {
                  _hoveredPoint = 'Apparent Wind';
                });
              } else if (position.dy == center.dy) {
                setState(() {
                  _hoveredPoint = 'True Wind';
                });
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTideCycleDiagram() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: TideCyclePainter(
            animation: _animation.value,
            hoveredPoint: _hoveredPoint,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) {
              final width = widget.size;
              final position = details.localPosition;
              
              // Determine which part of the tide cycle was tapped
              if (position.dx < width * 0.25) {
                setState(() {
                  _hoveredPoint = 'High Tide';
                });
              } else if (position.dx > width * 0.75) {
                setState(() {
                  _hoveredPoint = 'Low Tide';
                });
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationDiagram() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: NavigationPainter(
            rotation: _rotation,
            hoveredPoint: _hoveredPoint,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTapUp: (details) {
              final center = Offset(widget.size / 2, widget.size / 2);
              final position = details.localPosition;
              final angle = math.atan2(
                position.dy - center.dy,
                position.dx - center.dx,
              ) * 180 / math.pi;
              
              // Determine which cardinal point was tapped
              final points = [
                {'text': 'North', 'angle': -90.0},
                {'text': 'East', 'angle': 0.0},
                {'text': 'South', 'angle': 90.0},
                {'text': 'West', 'angle': 180.0},
              ];

              for (var point in points) {
                final pointAngle = point['angle'] as double;
                if ((angle - pointAngle).abs() < 20) {
                  setState(() {
                    _hoveredPoint = point['text'] as String;
                  });
                  break;
                }
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class PointsOfSailPainter extends CustomPainter {
  final double rotation;
  final String? hoveredPoint;

  PointsOfSailPainter({
    required this.rotation,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw wind direction arrow
    final windPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // Draw wind arrow
    canvas.drawLine(
      Offset(0, -radius),
      Offset(0, radius),
      windPaint,
    );
    canvas.drawLine(
      Offset(0, -radius),
      Offset(-10, -radius + 20),
      windPaint,
    );
    canvas.drawLine(
      Offset(0, -radius),
      Offset(10, -radius + 20),
      windPaint,
    );

    // Draw points of sail
    final points = [
      {'text': 'Close Hauled', 'angle': 45.0},
      {'text': 'Close Reach', 'angle': 67.5},
      {'text': 'Beam Reach', 'angle': 90.0},
      {'text': 'Broad Reach', 'angle': 135.0},
      {'text': 'Running', 'angle': 180.0},
    ];

    for (var point in points) {
      final angle = point['angle'] as double;
      final text = point['text'] as String;
      final isHovered = text == hoveredPoint;

      final pointPaint = Paint()
        ..color = isHovered ? Colors.yellow : Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = isHovered ? 3.0 : 2.0;

      final radians = angle * math.pi / 180;
      final x = radius * math.cos(radians);
      final y = radius * math.sin(radians);

      canvas.drawLine(
        Offset.zero,
        Offset(x, y),
        pointPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: isHovered ? Colors.yellow : Colors.white,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x + 10, y - 6),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WindDirectionPainter extends CustomPainter {
  final double animation;
  final String? hoveredPoint;

  WindDirectionPainter({
    required this.animation,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw true wind vector
    canvas.drawLine(
      center,
      Offset(center.dx + radius, center.dy),
      paint,
    );

    // Draw apparent wind vector with animation
    final apparentAngle = 30.0 * animation;
    final apparentX = radius * math.cos(apparentAngle * math.pi / 180);
    final apparentY = radius * math.sin(apparentAngle * math.pi / 180);

    canvas.drawLine(
      center,
      Offset(center.dx + apparentX, center.dy + apparentY),
      paint..color = Colors.yellow,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final labels = [
      {'text': 'True Wind', 'dx': center.dx + radius + 10, 'dy': center.dy},
      {'text': 'Apparent Wind', 'dx': center.dx + apparentX + 10, 'dy': center.dy + apparentY},
    ];

    for (var label in labels) {
      final text = label['text'] as String;
      final isHovered = text == hoveredPoint;

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: isHovered ? Colors.yellow : Colors.white,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(label['dx'] as double, (label['dy'] as double) - 6)
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TideCyclePainter extends CustomPainter {
  final double animation;
  final String? hoveredPoint;

  TideCyclePainter({
    required this.animation,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw moon
    final moonPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.2, moonPaint);

    // Draw tide level
    final tidePaint = Paint()
      ..color = Colors.blue.withValues(red: 0, green: 0, blue: 255, alpha: 128)
      ..style = PaintingStyle.fill;

    final tideHeight = radius * 0.8 * (0.5 + 0.5 * math.sin(animation * 2 * math.pi));
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 0.8,
        center.dy + radius * 0.8 - tideHeight,
        radius * 1.6,
        tideHeight,
      ),
      tidePaint,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final labels = [
      {'text': 'High Tide', 'dx': center.dx - radius * 0.8, 'dy': center.dy + radius * 0.8 - tideHeight - 20},
      {'text': 'Low Tide', 'dx': center.dx - radius * 0.8, 'dy': center.dy + radius * 0.8 + 20},
    ];

    for (var label in labels) {
      final text = label['text'] as String;
      final isHovered = text == hoveredPoint;

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: isHovered ? Colors.yellow : Colors.white,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(label['dx'] as double, (label['dy'] as double) - 6)
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NavigationPainter extends CustomPainter {
  final double rotation;
  final String? hoveredPoint;

  NavigationPainter({
    required this.rotation,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // Draw compass rose
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw cardinal points
    final points = [
      {'text': 'N', 'angle': -90.0},
      {'text': 'E', 'angle': 0.0},
      {'text': 'S', 'angle': 90.0},
      {'text': 'W', 'angle': 180.0},
    ];

    for (var point in points) {
      final angle = point['angle'] as double;
      final text = point['text'] as String;
      final isHovered = text == hoveredPoint;

      final radians = angle * math.pi / 180;
      final x = radius * math.cos(radians);
      final y = radius * math.sin(radians);

      canvas.drawLine(
        Offset.zero,
        Offset(x, y),
        paint..color = isHovered ? Colors.yellow : Colors.white,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: isHovered ? Colors.yellow : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 