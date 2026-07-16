import 'package:flutter/material.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class InspirationBanner extends StatelessWidget {
  const InspirationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return AppContentCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radii.card),
        child: SizedBox(
          height: 116,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _BannerPainter(tokens.colors)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  tokens.spacing.xl,
                  tokens.spacing.md,
                  130,
                  tokens.spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '每一天，都是更好的自己。',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.cardTitle.copyWith(
                        color: tokens.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: tokens.spacing.xs),
                    Text(
                      '一 日程 · 规划 · 专注 · 成长',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.helper.copyWith(
                        color: tokens.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerPainter extends CustomPainter {
  const _BannerPainter(this.colors);

  final AppColorTokens colors;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = LinearGradient(
        colors: [
          colors.surface,
          Color.lerp(colors.surfaceMuted, colors.primaryAction, 0.18)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final glow = Paint()
      ..color = colors.surface.withValues(alpha: 0.45)
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
    final deskPaint = Paint()
      ..color = Color.lerp(colors.primaryAction, colors.surface, 0.28)!;
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
    final bookColors = [
      Color.lerp(colors.primaryAction, colors.surface, 0.22)!,
      colors.surface,
      Color.lerp(colors.primaryAction, colors.textPrimary, 0.16)!,
    ];

    for (var index = 0; index < bookColors.length; index++) {
      final rect = Rect.fromLTWH(
        left + (index * 6),
        top + (index * 10),
        108 - (index * 8),
        12,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = bookColors[index],
      );
    }
  }

  void _drawCup(Canvas canvas, Size size) {
    final paint = Paint()..color = colors.surface;
    final stroke = Paint()
      ..color = colors.primaryAction
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
      ..color = colors.statusSuccess
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final potPaint = Paint()
      ..color = Color.lerp(colors.primaryAction, colors.surface, 0.36)!;
    final base = Offset(size.width * 0.72, size.height * 0.73);

    canvas.drawLine(base, Offset(base.dx - 10, base.dy - 62), stem);
    canvas.drawLine(base, Offset(base.dx + 8, base.dy - 55), stem);
    canvas.drawLine(base, Offset(base.dx - 2, base.dy - 72), stem);

    final leafPaint = Paint()
      ..color = Color.lerp(colors.statusSuccess, colors.textPrimary, 0.16)!;
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
  bool shouldRepaint(covariant _BannerPainter oldDelegate) {
    return colors != oldDelegate.colors;
  }
}
