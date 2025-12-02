import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Debug tool to find precise coordinates for mandala sections
/// Tap on the image to see pixel coordinates and percentages
class CoordinateHelper extends StatefulWidget {
  const CoordinateHelper({super.key});

  @override
  State<CoordinateHelper> createState() => _CoordinateHelperState();
}

class _CoordinateHelperState extends State<CoordinateHelper> {
  final List<Offset> _tapPoints = [];
  Size? _imageSize;

  void _handleTap(TapDownDetails details) {
    setState(() {
      _tapPoints.add(details.localPosition);
    });
  }

  void _clearPoints() {
    setState(() {
      _tapPoints.clear();
    });
  }

  void _removeLastPoint() {
    if (_tapPoints.isNotEmpty) {
      setState(() {
        _tapPoints.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1CA7EC),
        title: const Text(
          'Coordinate Helper',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: _removeLastPoint,
            tooltip: 'Remove last point',
          ),
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: _clearPoints,
            tooltip: 'Clear all points',
          ),
        ],
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: const Text(
              'Tap on the corners of each trapezoid section.\n'
              'Image size: 1344x1344 pixels',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          // Mandala with tap detection
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _imageSize = Size(constraints.maxWidth, constraints.maxHeight);

                    return GestureDetector(
                      onTapDown: _handleTap,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Mandala image
                          SvgPicture.asset(
                            'assets/images/logo.svg',
                            fit: BoxFit.contain,
                          ),

                          // Tap points overlay
                          CustomPaint(
                            painter: _PointsPainter(_tapPoints),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Coordinates display
          Container(
            height: 200,
            color: Colors.grey[100],
            child: ListView.builder(
              itemCount: _tapPoints.length,
              itemBuilder: (context, index) {
                final point = _tapPoints[index];
                final percentX = _imageSize != null
                    ? (point.dx / _imageSize!.width).toStringAsFixed(4)
                    : '0.0000';
                final percentY = _imageSize != null
                    ? (point.dy / _imageSize!.height).toStringAsFixed(4)
                    : '0.0000';

                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                  ),
                  title: Text(
                    'Point ${index + 1}: ($percentX, $percentY)',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                  subtitle: Text(
                    'Pixel: (${point.dx.toStringAsFixed(1)}, ${point.dy.toStringAsFixed(1)})',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),

          // Code generation button
          if (_tapPoints.length >= 4)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _showGeneratedCode,
                icon: const Icon(Icons.code),
                label: const Text('Generate Clipper Code'),
              ),
            ),
        ],
      ),
    );
  }

  void _showGeneratedCode() {
    if (_tapPoints.length < 4) return;

    // Take last 4 points
    final points = _tapPoints.sublist(_tapPoints.length - 4);
    final code = _generateClipperCode(points);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Clipper Code'),
        content: SingleChildScrollView(
          child: SelectableText(
            code,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _generateClipperCode(List<Offset> points) {
    if (_imageSize == null) return '';

    final coords = points.map((p) {
      final x = (p.dx / _imageSize!.width).toStringAsFixed(4);
      final y = (p.dy / _imageSize!.height).toStringAsFixed(4);
      return 'path.lineTo(w * $x, h * $y);';
    }).join('\n    ');

    return '''
@override
Path getClip(Size size) {
  final path = Path();
  final w = size.width;
  final h = size.height;

  path.moveTo(w * ${(points[0].dx / _imageSize!.width).toStringAsFixed(4)}, h * ${(points[0].dy / _imageSize!.height).toStringAsFixed(4)});
  ${coords.substring(coords.indexOf('\n') + 1)}
  path.close();

  return path;
}''';
  }
}

class _PointsPainter extends CustomPainter {
  final List<Offset> points;

  _PointsPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw lines connecting points
    if (points.length > 1) {
      final linePaint = Paint()
        ..color = Colors.red.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 6, pointPaint);

      // Draw point number
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - 4, points[i].dy - 6),
      );
    }
  }

  @override
  bool shouldRepaint(_PointsPainter oldDelegate) => true;
}
