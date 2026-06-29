import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mind_boost/theme/app_theme.dart';

class CuteRobotIllustration extends StatelessWidget {
  final double size;
  const CuteRobotIllustration({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CuteRobotPainter()),
    );
  }
}

class _CuteRobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bodyPaint = Paint()
      ..color = AppTheme.lavender
      ..style = PaintingStyle.fill;

    final Paint accentPaint = Paint()
      ..color = AppTheme.lavenderDark
      ..style = PaintingStyle.fill;

    final Paint screenPaint = Paint()
      ..color = AppTheme.lightBlueLight
      ..style = PaintingStyle.fill;

    final Paint eyePaint = Paint()
      ..color = AppTheme.mintDark
      ..style = PaintingStyle.fill;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Center point
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTRB(
        cx - size.width * 0.35,
        size.height - 15,
        cx + size.width * 0.35,
        size.height,
      ),
      shadowPaint,
    );

    // Draw Ears / Antennas
    canvas.drawRect(
      Rect.fromLTWH(cx - 30, cy - size.height * 0.35, 60, 10),
      accentPaint,
    );
    canvas.drawCircle(Offset(cx, cy - size.height * 0.35), 8, accentPaint);

    // Draw Robot Ears
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          cx - size.width * 0.38,
          cy - 15,
          cx - size.width * 0.3,
          cy + 15,
        ),
        const Radius.circular(8),
      ),
      accentPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          cx + size.width * 0.3,
          cy - 15,
          cx + size.width * 0.38,
          cy + 15,
        ),
        const Radius.circular(8),
      ),
      accentPaint,
    );

    // Draw Main Head/Body (rounded rectangle)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          cx - size.width * 0.32,
          cy - size.height * 0.3,
          cx + size.width * 0.32,
          cy + size.height * 0.25,
        ),
        const Radius.circular(32),
      ),
      bodyPaint,
    );

    // Draw Screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          cx - size.width * 0.25,
          cy - size.height * 0.2,
          cx + size.width * 0.25,
          cy + size.height * 0.1,
        ),
        const Radius.circular(20),
      ),
      screenPaint,
    );

    // Draw Eyes (cute glowing circles or semi-circles)
    canvas.drawCircle(
      Offset(cx - size.width * 0.11, cy - size.height * 0.05),
      10,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.11, cy - size.height * 0.05),
      10,
      eyePaint,
    );

    // Eye highlights
    canvas.drawCircle(
      Offset(cx - size.width * 0.13, cy - size.height * 0.07),
      3,
      whitePaint,
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.09, cy - size.height * 0.07),
      3,
      whitePaint,
    );

    // Cute blush cheeks
    final Paint blushPaint = Paint()
      ..color = Colors.pinkAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(cx - size.width * 0.18, cy + size.height * 0.02),
      7,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.18, cy + size.height * 0.02),
      7,
      blushPaint,
    );

    // Draw Smile
    final Paint smilePaint = Paint()
      ..color = AppTheme.darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final Path smilePath = Path();
    smilePath.arcTo(
      Rect.fromCircle(center: Offset(cx, cy + size.height * 0.01), radius: 8),
      0,
      pi,
      true,
    );
    canvas.drawPath(smilePath, smilePaint);

    // Cute study tie / collar
    final Path collar = Path()
      ..moveTo(cx - 15, cy + size.height * 0.25)
      ..lineTo(cx + 15, cy + size.height * 0.25)
      ..lineTo(cx, cy + size.height * 0.32)
      ..close();
    canvas.drawPath(collar, accentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BookIllustration extends StatelessWidget {
  final double size;
  const BookIllustration({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BookPainter()),
    );
  }
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Shadow
    canvas.drawOval(
      Rect.fromLTRB(
        cx - size.width * 0.4,
        size.height - 12,
        cx + size.width * 0.4,
        size.height,
      ),
      Paint()..color = Colors.black.withOpacity(0.04),
    );

    // Book Cover (Bottom)
    final Paint coverPaint = Paint()
      ..color = AppTheme.lavenderDark
      ..style = PaintingStyle.fill;

    final Path coverPath = Path()
      ..moveTo(cx - size.width * 0.42, cy + 12)
      ..quadraticBezierTo(cx - size.width * 0.2, cy + 22, cx, cy + 14)
      ..quadraticBezierTo(
        cx + size.width * 0.2,
        cy + 22,
        cx + size.width * 0.42,
        cy + 12,
      )
      ..lineTo(cx + size.width * 0.4, cy + 20)
      ..quadraticBezierTo(cx + size.width * 0.2, cy + 30, cx, cy + 22)
      ..quadraticBezierTo(
        cx - size.width * 0.2,
        cy + 30,
        cx - size.width * 0.4,
        cy + 20,
      )
      ..close();
    canvas.drawPath(coverPath, coverPaint);

    // Book Pages (Main White)
    final Paint pagePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppTheme.darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final Path leftPage = Path()
      ..moveTo(cx - 2, cy + 10)
      ..quadraticBezierTo(
        cx - size.width * 0.2,
        cy + 18,
        cx - size.width * 0.4,
        cy + 8,
      )
      ..lineTo(cx - size.width * 0.4, cy - size.height * 0.25)
      ..quadraticBezierTo(
        cx - size.width * 0.2,
        cy - size.height * 0.15,
        cx - 2,
        cy - size.height * 0.23,
      )
      ..close();

    final Path rightPage = Path()
      ..moveTo(cx + 2, cy + 10)
      ..quadraticBezierTo(
        cx + size.width * 0.2,
        cy + 18,
        cx + size.width * 0.4,
        cy + 8,
      )
      ..lineTo(cx + size.width * 0.4, cy - size.height * 0.25)
      ..quadraticBezierTo(
        cx + size.width * 0.2,
        cy - size.height * 0.15,
        cx + 2,
        cy - size.height * 0.23,
      )
      ..close();

    canvas.drawPath(leftPage, pagePaint);
    canvas.drawPath(leftPage, borderPaint);
    canvas.drawPath(rightPage, pagePaint);
    canvas.drawPath(rightPage, borderPaint);

    // Book spine lines
    canvas.drawLine(
      Offset(cx, cy - size.height * 0.23),
      Offset(cx, cy + 11),
      borderPaint,
    );

    // Sparkles
    final Paint sparkPaint = Paint()
      ..color = AppTheme.peachDark
      ..style = PaintingStyle.fill;

    // Draw small diamond spark
    void drawSpark(double x, double y, double s) {
      final Path path = Path()
        ..moveTo(x, y - s)
        ..lineTo(x + s / 2, y)
        ..lineTo(x, y + s)
        ..lineTo(x - s / 2, y)
        ..close();
      canvas.drawPath(path, sparkPaint);
    }

    drawSpark(cx - size.width * 0.28, cy - size.height * 0.35, 10);
    drawSpark(cx + size.width * 0.3, cy - size.height * 0.28, 8);
    drawSpark(cx + 10, cy - size.height * 0.42, 12);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FireIllustration extends StatelessWidget {
  final double size;
  const FireIllustration({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FirePainter()),
    );
  }
}

class _FirePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw Flame Outer Path
    final Paint outerFlame = Paint()
      ..color = AppTheme.peachDark
      ..style = PaintingStyle.fill;

    final Paint innerFlame = Paint()
      ..color = Colors.redAccent.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final Paint eyePaint = Paint()
      ..color = AppTheme.darkCharcoal
      ..style = PaintingStyle.fill;

    // Flame Path
    final Path path = Path()
      ..moveTo(cx, cy + size.height * 0.4)
      ..cubicTo(
        cx - size.width * 0.45,
        cy + size.height * 0.4,
        cx - size.width * 0.4,
        cy - size.height * 0.1,
        cx - size.width * 0.1,
        cy - size.height * 0.35,
      )
      ..cubicTo(
        cx - size.width * 0.05,
        cy - size.height * 0.45,
        cx,
        cy - size.height * 0.5,
        cx,
        cy - size.height * 0.5,
      )
      ..cubicTo(
        cx + size.width * 0.05,
        cy - size.height * 0.25,
        cx + size.width * 0.3,
        cy - size.height * 0.15,
        cx + size.width * 0.35,
        cy + size.height * 0.1,
      )
      ..cubicTo(
        cx + size.width * 0.4,
        cy + size.height * 0.3,
        cx + size.width * 0.2,
        cy + size.height * 0.4,
        cx,
        cy + size.height * 0.4,
      )
      ..close();
    canvas.drawPath(path, outerFlame);

    // Inner Flame
    final Path innerPath = Path()
      ..moveTo(cx, cy + size.height * 0.3)
      ..cubicTo(
        cx - size.width * 0.25,
        cy + size.height * 0.3,
        cx - size.width * 0.22,
        cy - size.height * 0.05,
        cx - size.width * 0.05,
        cy - size.height * 0.2,
      )
      ..cubicTo(
        cx,
        cy - size.height * 0.25,
        cx,
        cy - size.height * 0.3,
        cx,
        cy - size.height * 0.3,
      )
      ..cubicTo(
        cx + size.width * 0.05,
        cy - size.height * 0.1,
        cx + size.width * 0.15,
        cy - size.height * 0.05,
        cx + size.width * 0.2,
        cy + size.height * 0.1,
      )
      ..cubicTo(
        cx + size.width * 0.25,
        cy + size.height * 0.2,
        cx + size.width * 0.1,
        cy + size.height * 0.3,
        cx,
        cy + size.height * 0.3,
      )
      ..close();
    canvas.drawPath(innerPath, innerFlame);

    // Cute smiley eyes
    canvas.drawCircle(Offset(cx - 6, cy + 5), 2.5, eyePaint);
    canvas.drawCircle(Offset(cx + 6, cy + 5), 2.5, eyePaint);

    // Smile
    final Paint smilePaint = Paint()
      ..color = AppTheme.darkCharcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final Path smile = Path();
    smile.arcTo(
      Rect.fromCircle(center: Offset(cx, cy + 8), radius: 3),
      0,
      pi,
      true,
    );
    canvas.drawPath(smile, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CuteOwlIllustration extends StatelessWidget {
  final double size;
  const CuteOwlIllustration({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CuteOwlPainter()),
    );
  }
}

class _CuteOwlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTRB(
        cx - size.width * 0.45,
        size.height - 15,
        cx + size.width * 0.45,
        size.height,
      ),
      shadowPaint,
    );

    // Draw Stack of Books
    // Book 1 (Bottom - Blue)
    final Paint book1Paint = Paint()
      ..color = AppTheme.lightBlueDark
      ..style = PaintingStyle.fill;
    final Paint bookPagePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(cx - size.width * 0.4, size.height - 35, cx + size.width * 0.35, size.height - 15),
        const Radius.circular(6),
      ),
      book1Paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(cx + size.width * 0.22, size.height - 32, cx + size.width * 0.33, size.height - 18),
      bookPagePaint,
    );

    // Book 2 (Top - Red/Coral)
    final Paint book2Paint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(cx - size.width * 0.35, size.height - 50, cx + size.width * 0.38, size.height - 35),
        const Radius.circular(6),
      ),
      book2Paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(cx + size.width * 0.25, size.height - 47, cx + size.width * 0.36, size.height - 38),
      bookPagePaint,
    );

    // Draw Yellow Pot/Cup on left
    final Paint cupPaint = Paint()
      ..color = AppTheme.peachDark
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(cx - size.width * 0.42, size.height - 35, cx - size.width * 0.3, size.height - 15),
        const Radius.circular(4),
      ),
      cupPaint,
    );
    // Mug handle
    final Paint handlePaint = Paint()
      ..color = AppTheme.peachDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromLTWH(cx - size.width * 0.46, size.height - 30, 10, 15),
      pi / 2,
      pi,
      false,
      handlePaint,
    );

    // Draw Owl body (cute purple oval)
    final Paint owlBodyPaint = Paint()
      ..color = const Color(0xFF9E8CF4) // Cute violet
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTRB(cx - size.width * 0.26, cy - size.height * 0.22, cx + size.width * 0.26, size.height - 45),
      owlBodyPaint,
    );

    // Owl ears (purple triangles)
    final Path leftEar = Path()
      ..moveTo(cx - size.width * 0.23, cy - size.height * 0.18)
      ..lineTo(cx - size.width * 0.25, cy - size.height * 0.32)
      ..lineTo(cx - size.width * 0.08, cy - size.height * 0.22)
      ..close();
    final Path rightEar = Path()
      ..moveTo(cx + size.width * 0.23, cy - size.height * 0.18)
      ..lineTo(cx + size.width * 0.25, cy - size.height * 0.32)
      ..lineTo(cx + size.width * 0.08, cy - size.height * 0.22)
      ..close();
    canvas.drawPath(leftEar, owlBodyPaint);
    canvas.drawPath(rightEar, owlBodyPaint);

    // Owl belly chest (light lavender/cream)
    final Paint chestPaint = Paint()
      ..color = const Color(0xFFF1EEFF)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTRB(cx - size.width * 0.16, cy + 5, cx + size.width * 0.16, size.height - 50),
      chestPaint,
    );

    // Owl wings
    final Paint wingPaint = Paint()
      ..color = const Color(0xFF7E66EE)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTRB(cx - size.width * 0.32, cy - 10, cx - size.width * 0.22, cy + 30),
      wingPaint,
    );
    canvas.drawOval(
      Rect.fromLTRB(cx + size.width * 0.22, cy - 10, cx + size.width * 0.32, cy + 30),
      wingPaint,
    );

    // Owl big cute eyes
    final Paint eyeWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint eyeIris = Paint()
      ..color = const Color(0xFF5E3BE1)
      ..style = PaintingStyle.fill;
    final Paint eyePupil = Paint()
      ..color = AppTheme.darkCharcoal
      ..style = PaintingStyle.fill;

    // Left eye outer
    canvas.drawCircle(Offset(cx - size.width * 0.11, cy - size.height * 0.06), 18, eyeWhite);
    // Right eye outer
    canvas.drawCircle(Offset(cx + size.width * 0.11, cy - size.height * 0.06), 18, eyeWhite);

    // Left iris
    canvas.drawCircle(Offset(cx - size.width * 0.1, cy - size.height * 0.06), 12, eyeIris);
    // Right iris
    canvas.drawCircle(Offset(cx + size.width * 0.1, cy - size.height * 0.06), 12, eyeIris);

    // Left pupil
    canvas.drawCircle(Offset(cx - size.width * 0.09, cy - size.height * 0.06), 8, eyePupil);
    // Right pupil
    canvas.drawCircle(Offset(cx + size.width * 0.09, cy - size.height * 0.06), 8, eyePupil);

    // Eye highlights (sparkles)
    canvas.drawCircle(Offset(cx - size.width * 0.11, cy - size.height * 0.08), 3, eyeWhite);
    canvas.drawCircle(Offset(cx + size.width * 0.07, cy - size.height * 0.08), 3, eyeWhite);
    canvas.drawCircle(Offset(cx - size.width * 0.07, cy - size.height * 0.04), 1.5, eyeWhite);
    canvas.drawCircle(Offset(cx + size.width * 0.11, cy - size.height * 0.04), 1.5, eyeWhite);

    // Beak (cute orange/yellow triangle)
    final Paint beakPaint = Paint()
      ..color = const Color(0xFFFFB830)
      ..style = PaintingStyle.fill;
    final Path beakPath = Path()
      ..moveTo(cx - 6, cy - size.height * 0.02)
      ..lineTo(cx + 6, cy - size.height * 0.02)
      ..lineTo(cx, cy + 6)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // Owl Feet (orange/yellow oval claws)
    canvas.drawOval(Rect.fromLTWH(cx - 20, size.height - 52, 12, 8), beakPaint);
    canvas.drawOval(Rect.fromLTWH(cx + 8, size.height - 52, 12, 8), beakPaint);

    // Draw Graduation Cap (Mortarboard) on head
    final Paint capPaint = Paint()
      ..color = const Color(0xFF333333) // Dark charcoal cap
      ..style = PaintingStyle.fill;

    // Cap base band
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(cx - 20, cy - size.height * 0.28, cx + 20, cy - size.height * 0.22),
        const Radius.circular(3),
      ),
      capPaint,
    );

    // Cap Diamond Top
    final Path diamond = Path()
      ..moveTo(cx, cy - size.height * 0.38) // Top peak
      ..lineTo(cx + 42, cy - size.height * 0.30) // Right peak
      ..lineTo(cx, cy - size.height * 0.22) // Bottom peak
      ..lineTo(cx - 42, cy - size.height * 0.30) // Left peak
      ..close();
    canvas.drawPath(diamond, capPaint);

    // Cap Tassel (yellow string hanging)
    final Paint tasselPaint = Paint()
      ..color = const Color(0xFFFFD369) // Golden yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(cx, cy - size.height * 0.30),
      Offset(cx - 30, cy - size.height * 0.25),
      tasselPaint,
    );
    canvas.drawCircle(Offset(cx - 30, cy - size.height * 0.23), 3, Paint()..color = const Color(0xFFFFD369));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
