import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';

class InspirationBanner extends StatelessWidget {
  const InspirationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 22,
      child: SizedBox(
        height: 136,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CustomPaint(painter: _BannerPainter()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 24, 180, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '每一天，都是更好的自己。',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: warmBrown,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    '一 日程 · 规划 · 专注 · 成长',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: warmBrown.withValues(alpha: 0.72),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xfffff8ef), Color(0xfff4dbc2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final glow = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.34, size.height * 0.3),
        width: size.width * 0.35,
        height: size.height * 0.8,
      ),
      glow,
    );

    _drawDesk(canvas, size);
    _drawBooks(canvas, size);
    _drawCup(canvas, size);
    _drawPlant(canvas, size);
  }

  void _drawDesk(Canvas canvas, Size size) {
    final deskPaint = Paint()..color = const Color(0xffd2a165);
    final top = size.height * 0.8;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.56, top, size.width * 0.38, 12),
        const Radius.circular(4),
      ),
      deskPaint,
    );
  }

  void _drawBooks(Canvas canvas, Size size) {
    final left = size.width * 0.55;
    final top = size.height * 0.67;
    final colors = [
      const Color(0xffd6a46d),
      const Color(0xfffff4e3),
      const Color(0xffc68f55),
    ];

    for (var index = 0; index < 3; index++) {
      final rect = Rect.fromLTWH(
        left + (index * 6),
        top + (index * 10),
        108 - (index * 8),
        12,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = colors[index],
      );
    }
  }

  void _drawCup(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xfffff4df);
    final stroke = Paint()
      ..color = const Color(0xffa8733e)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final cup = Rect.fromLTWH(size.width * 0.78, size.height * 0.62, 44, 34);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cup, const Radius.circular(12)),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(cup.right - 3, cup.top + 7, 24, 19),
      -1.2,
      2.4,
      false,
      stroke,
    );
  }

  void _drawPlant(Canvas canvas, Size size) {
    final stem = Paint()
      ..color = const Color(0xff668145)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final potPaint = Paint()..color = const Color(0xffd5ad79);
    final base = Offset(size.width * 0.72, size.height * 0.73);

    canvas.drawLine(base, Offset(base.dx - 10, base.dy - 62), stem);
    canvas.drawLine(base, Offset(base.dx + 8, base.dy - 55), stem);
    canvas.drawLine(base, Offset(base.dx - 2, base.dy - 72), stem);

    final leafPaint = Paint()..color = const Color(0xff7d9551);
    for (final offset in const [
      Offset(-24, -48),
      Offset(-8, -64),
      Offset(13, -50),
      Offset(-18, -78),
      Offset(10, -82),
      Offset(23, -68),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: base + offset, width: 29, height: 12),
        leafPaint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: base + const Offset(1, 10),
          width: 38,
          height: 26,
        ),
        const Radius.circular(8),
      ),
      potPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
