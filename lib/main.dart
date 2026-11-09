import 'dart:math' as math;

import 'package:flutter/material.dart';

const _gold = Color(0xFFE8BD72);
const _canvas = Color(0xFF343434);
const _card = Color(0xFF1E1E1E);

void main() => runApp(const IslamiApp());

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Islami',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _canvas,
          colorScheme: const ColorScheme.dark(primary: _gold, surface: _card),
          fontFamily: 'Arial',
        ),
        home: const TaskBoard(),
      );
}

class TaskBoard extends StatefulWidget {
  const TaskBoard({super.key});

  static const pages = <_IntroData>[
    _IntroData('Welcome To Islami App', '', _Art.calligraphy, 'Next'),
    _IntroData('Welcome To Islami', 'We Are Very Excited To Have You In Our Community', _Art.mosque, 'Next'),
    _IntroData('Reading the Quran', 'Read, and your Lord is the Most Generous', _Art.quran, 'Next'),
    _IntroData('Bearish', 'Praise the name of your Lord, the Most High', _Art.prayer, 'Next'),
    _IntroData('Holy Quran Radio', 'You can listen to the Holy Quran Radio through the application for free and easily', _Art.microphone, 'Finish'),
  ];

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _goTo(int page) => _controller.animateToPage(page, duration: const Duration(milliseconds: 280), curve: Curves.easeInOut);

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _card,
        body: SafeArea(
          child: PageView.builder(
            controller: _controller,
            itemCount: TaskBoard.pages.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) => _PhoneIntroScreen(
              data: TaskBoard.pages[index], index: index, currentPage: _currentPage,
              onBack: index == 0 ? null : () => _goTo(index - 1),
              onNext: index == TaskBoard.pages.length - 1 ? null : () => _goTo(index + 1),
              onFinish: index == TaskBoard.pages.length - 1 ? () => _goTo(0) : null,
            ),
          ),
        ),
      );
}

class _IntroData {
  final String title;
  final String subtitle;
  final _Art art;
  final String action;
  const _IntroData(this.title, this.subtitle, this.art, this.action);
}

enum _Art { calligraphy, mosque, quran, prayer, microphone }

class _PhoneIntroScreen extends StatelessWidget {
  final _IntroData data;
  final int index;
  final int currentPage;
  final VoidCallback? onBack, onNext, onFinish;
  const _PhoneIntroScreen({required this.data, required this.index, required this.currentPage, required this.onBack, required this.onNext, required this.onFinish});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        final scale = math.min(1.0, constraints.maxWidth / 430);
        final horizontalPadding = 24 * scale;
        final artSize = math.min((constraints.maxWidth - horizontalPadding * 2) * .88, height * .48);
        return Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16 * scale),
          child: Column(children: [
            SizedBox(height: 16 * scale),
            _Brand(scale: scale),
            SizedBox(height: 10 * scale),
            SizedBox(height: artSize, width: artSize, child: _HeroArt(kind: data.art)),
            SizedBox(height: height * .045),
            Text(data.title, textAlign: TextAlign.center, style: const TextStyle(color: _gold, fontSize: 20, fontWeight: FontWeight.w500)),
            if (data.subtitle.isNotEmpty) ...[
              const SizedBox(height: 22),
              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 310), child: Text(data.subtitle, textAlign: TextAlign.center, style: const TextStyle(color: _gold, fontSize: 15, height: 1.6))),
            ],
            const Spacer(),
            Row(children: [
              SizedBox(width: 56, child: onBack == null ? null : Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: onBack, style: TextButton.styleFrom(foregroundColor: _gold, padding: EdgeInsets.zero), child: const Text('Back')))),
              const Spacer(),
              ...List.generate(TaskBoard.pages.length, (i) => GestureDetector(
                    onTap: () => _goPage(context, i),
                    child: AnimatedContainer(duration: const Duration(milliseconds: 180), width: i == currentPage ? 15 : 5, height: 5, margin: const EdgeInsets.symmetric(horizontal: 3), decoration: BoxDecoration(color: i == currentPage ? _gold : const Color(0xFF777777), borderRadius: BorderRadius.circular(8))),
                  )),
              const Spacer(),
              SizedBox(width: 56, child: Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onFinish ?? onNext, style: TextButton.styleFrom(foregroundColor: _gold, padding: EdgeInsets.zero), child: Text(onFinish == null ? 'Next' : 'Finish')))),
            ]),
          ]),
        );
      });

  void _goPage(BuildContext context, int page) => context.findAncestorStateOfType<_TaskBoardState>()?._goTo(page);
}

class _Brand extends StatelessWidget {
  final double scale;
  const _Brand({required this.scale});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 291 * scale,
        height: 171 * scale,
        child: Stack(clipBehavior: Clip.none, children: [
          Image.asset(
            'assets/images/islami_logo.png',
            width: 291 * scale,
            height: 151 * scale,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            left: 63 * scale,
            top: 75 * scale,
            width: 166 * scale,
            height: 96 * scale,
            child: FittedBox(
              fit: BoxFit.contain,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFFC0A37C), Color(0xFFFFD482)]).createShader(bounds),
                child: const Text(
                  'Islami',
                  style: TextStyle(color: Colors.white, fontFamily: 'Kamali', fontSize: 80, fontWeight: FontWeight.w400, height: 1, letterSpacing: 0),
                ),
              ),
            ),
          ),
        ]),
      );
}

class _HeroArt extends StatelessWidget {
  final _Art kind;
  const _HeroArt({required this.kind});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final side = math.min(c.maxWidth, c.maxHeight);
        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: kind == _Art.calligraphy
                ? Center(child: Text('محمد\nرسول الله', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: _gold, fontSize: side * .25, height: .95, fontWeight: FontWeight.w900, shadows: [Shadow(color: _gold.withOpacity(.4), blurRadius: 9)])))
                : Image.asset(_imageFor(kind), fit: BoxFit.contain),
          ),
        );
      });

  String _imageFor(_Art art) => switch (art) {
        _Art.mosque => 'assets/images/mosque.png',
        _Art.quran => 'assets/images/quran.png',
        _Art.prayer => 'assets/images/prayer.png',
        _Art.microphone => 'assets/images/microphone.png',
        _Art.calligraphy => '',
      };
}

class _IllustrationPainter extends CustomPainter {
  final _Art kind;
  _IllustrationPainter(this.kind);
  final Paint p = Paint()..color = _gold..style = PaintingStyle.stroke..strokeWidth = 1.35..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
  final Paint fill = Paint()..color = _gold.withOpacity(.13)..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * .08, size.height * .08);
    canvas.scale(size.width * .84 / 200, size.height * .84 / 200);
    if (kind == _Art.mosque) _mosque(canvas);
    if (kind == _Art.quran) _quran(canvas);
    if (kind == _Art.prayer) _prayer(canvas);
    if (kind == _Art.microphone) _microphone(canvas);
    canvas.restore();
  }

  void _mosque(Canvas c) {
    // Ground and the grand central dome.
    c.drawLine(const Offset(12, 170), const Offset(188, 170), p);
    c.drawRect(const Rect.fromLTWH(34, 118, 132, 52), p);
    c.drawArc(const Rect.fromLTWH(55, 42, 90, 100), math.pi, math.pi, false, p);
    c.drawLine(const Offset(55, 92), const Offset(145, 92), p);
    c.drawCircle(const Offset(100, 39), 2, p);
    c.drawLine(const Offset(100, 37), const Offset(100, 25), p);
    c.drawArc(const Rect.fromLTWH(90, 75, 20, 34), math.pi, math.pi, false, p);
    for (final x in [45.0, 155.0]) {
      c.drawRect(Rect.fromLTWH(x - 5, 60, 10, 110), p);
      c.drawLine(Offset(x - 8, 65), Offset(x, 43), p);
      c.drawLine(Offset(x, 43), Offset(x + 8, 65), p);
      c.drawLine(Offset(x - 8, 79), Offset(x + 8, 79), p);
      c.drawLine(Offset(x - 6, 84), Offset(x + 6, 84), p);
      c.drawRect(Rect.fromLTWH(x - 8, 116, 16, 2), p);
      c.drawArc(Rect.fromLTWH(x - 7, 122, 14, 27), math.pi, math.pi, false, p);
    }
    for (final x in [70.0, 100.0, 130.0]) {
      c.drawArc(Rect.fromLTWH(x - 10, 138, 20, 32), math.pi, math.pi, false, p);
      c.drawLine(Offset(x - 10, 154), Offset(x + 10, 154), p);
    }
    c.drawRect(const Rect.fromLTWH(26, 144, 148, 26), fill);
    c.drawRect(const Rect.fromLTWH(26, 144, 148, 26), p);
  }

  void _quran(Canvas c) {
    c.drawLine(const Offset(100, 10), const Offset(100, 51), p);
    c.drawCircle(const Offset(100, 8), 2, p);
    for (final x in [46.0, 100.0, 154.0]) {
      c.drawLine(Offset(x, 15), Offset(x, 67), p);
      c.drawLine(Offset(x - 6, 28), Offset(x + 6, 28), p);
      c.drawLine(Offset(x - 6, 45), Offset(x + 6, 45), p);
      c.drawLine(Offset(x - 9, 67), Offset(x + 9, 67), p);
      c.drawCircle(Offset(x, 12), 2, p);
    }
    // Stand and open pages.
    final left = Path()..moveTo(100, 145)..lineTo(28, 116)..lineTo(37, 97)..lineTo(99, 122)..close();
    final right = Path()..moveTo(100, 145)..lineTo(172, 116)..lineTo(163, 97)..lineTo(101, 122)..close();
    c.drawPath(left, fill); c.drawPath(left, p); c.drawPath(right, fill); c.drawPath(right, p);
    c.drawLine(const Offset(100, 122), const Offset(100, 145), p);
    for (var i = 0; i < 3; i++) {
      c.drawLine(Offset(48, 106 + i * 5), Offset(91, 123 + i * 5), p);
      c.drawLine(Offset(109, 123 + i * 5), Offset(152, 106 + i * 5), p);
    }
    c.drawLine(const Offset(100, 145), const Offset(64, 180), p);
    c.drawLine(const Offset(100, 145), const Offset(136, 180), p);
    c.drawLine(const Offset(64, 180), const Offset(136, 180), p);
    // A small string of prayer beads.
    final beadPath = Path()..moveTo(114, 143)..cubicTo(179, 146, 171, 184, 130, 185);
    c.drawPath(beadPath, p);
    for (var i = 0; i < 13; i++) {
      final t = i / 12;
      final x = 114 + 61 * t;
      final y = 143 + 8 * math.sin(t * math.pi) + 34 * t;
      c.drawCircle(Offset(x, y), 1.6, Paint()..color = _gold..style = PaintingStyle.fill);
    }
  }

  void _prayer(Canvas c) {
    // Sleeves, palms and a strand of beads between cupped hands.
    final l = Path()..moveTo(40, 188)..lineTo(72, 119)..lineTo(79, 85)..lineTo(87, 55)..lineTo(96, 45)..lineTo(99, 82)..lineTo(104, 40)..lineTo(111, 43)..lineTo(111, 81)..lineTo(119, 50)..lineTo(126, 54)..lineTo(118, 95)..lineTo(135, 71)..lineTo(142, 77)..lineTo(126, 115)..lineTo(106, 137)..lineTo(89, 156)..close();
    final r = Path()..moveTo(160, 188)..lineTo(128, 119)..lineTo(121, 85)..lineTo(113, 55)..lineTo(104, 45)..lineTo(101, 82)..lineTo(96, 40)..lineTo(89, 43)..lineTo(89, 81)..lineTo(81, 50)..lineTo(74, 54)..lineTo(82, 95)..lineTo(65, 71)..lineTo(58, 77)..lineTo(74, 115)..lineTo(94, 137)..lineTo(111, 156)..close();
    c.drawPath(l, fill); c.drawPath(l, p); c.drawPath(r, fill); c.drawPath(r, p);
    for (var i = 0; i < 18; i++) {
      final t = i / 17;
      final x = 67 + 66 * t;
      final y = 91 + 34 * math.sin(t * math.pi);
      c.drawCircle(Offset(x, y), 2.1, Paint()..color = _gold..style = PaintingStyle.fill);
    }
    c.drawLine(const Offset(100, 121), const Offset(100, 153), p);
    c.drawCircle(const Offset(100, 157), 3, p);
    c.drawLine(const Offset(100, 160), const Offset(96, 174), p);
    c.drawLine(const Offset(100, 160), const Offset(104, 174), p);
  }

  void _microphone(Canvas c) {
    c.save();
    c.translate(100, 96);
    c.rotate(-.35);
    final body = RRect.fromRectAndRadius(const Rect.fromLTWH(-36, -82, 72, 118), const Radius.circular(34));
    c.drawRRect(body, fill); c.drawRRect(body, p);
    for (var y = -66.0; y <= 3; y += 12) {
      c.drawLine(Offset(-30, y), Offset(30, y), p);
      c.drawArc(Rect.fromCenter(center: Offset(0, y), width: 60, height: 20), 0, math.pi, false, p);
    }
    c.drawArc(const Rect.fromLTRB(-49, -32, 49, 73), 0, math.pi, false, p);
    c.drawLine(const Offset(0, 72), const Offset(0, 102), p);
    c.drawArc(const Rect.fromLTRB(-20, 91, 20, 111), 0, math.pi, false, p);
    c.drawLine(const Offset(-18, 107), const Offset(18, 107), p);
    c.restore();
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter oldDelegate) => oldDelegate.kind != kind;
}

class _MosquePainter extends CustomPainter {
  final bool subtle;
  const _MosquePainter({this.subtle = false});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 166, size.height / 96);
    final paint = Paint()
      ..color = _gold.withOpacity(subtle ? .29 : .8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .72
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // A small skyline of domes and minarets frames the wordmark, as in the
    // Figma logo artwork. The center is intentionally light so the letters
    // stay clear in front of the illustration.
    const w = 166.0;
    const baseline = 85.0;
    canvas.drawLine(const Offset(w * .06, baseline), const Offset(w * .94, baseline), paint);

    void minaret(double x, double tip, double foot, {double width = 6}) {
      final w = width;
      final p = Path()
        ..moveTo(x - w * .55, foot)
        ..lineTo(x - w * .45, tip + 14)
        ..lineTo(x, tip)
        ..lineTo(x + w * .45, tip + 14)
        ..lineTo(x + w * .55, foot);
      canvas.drawPath(p, paint);
      canvas.drawLine(Offset(x - w * .8, tip + 15), Offset(x + w * .8, tip + 15), paint);
      canvas.drawLine(Offset(x - w * .67, tip + 35), Offset(x + w * .67, tip + 35), paint);
      canvas.drawLine(Offset(x, tip - 2), Offset(x, tip - 8), paint);
      canvas.drawCircle(Offset(x, tip - 9), 1.05, paint);
    }

    void dome(double x, double width, double top, double base) {
      final rect = Rect.fromLTRB(x - width / 2, top, x + width / 2, base);
      canvas.drawArc(rect, math.pi, math.pi, false, paint);
      canvas.drawLine(Offset(rect.left, base), Offset(rect.right, base), paint);
      canvas.drawLine(Offset(x, top), Offset(x, top - 5), paint);
      canvas.drawCircle(Offset(x, top - 6), .9, paint);
    }

    // Outer towers and the smaller side domes.
    minaret(w * .13, 13, baseline, width: 5);
    minaret(w * .87, 15, baseline, width: 5);
    minaret(w * .30, 34, baseline, width: 4);
    minaret(w * .70, 34, baseline, width: 4);
    dome(w * .23, w * .22, 56, 76);
    dome(w * .77, w * .22, 56, 76);
    // Main central cupola and the roof lines beneath it.
    dome(w * .50, w * .38, 4, 66);
    canvas.drawLine(const Offset(w * .18, 77), const Offset(w * .82, 77), paint);
    canvas.drawLine(const Offset(w * .24, 81), const Offset(w * .76, 81), paint);
    for (final x in [.38, .44, .56, .62]) {
      final arch = Path()
        ..moveTo(w * x, baseline)
        ..lineTo(w * x, 72)
        ..quadraticBezierTo(w * (x + .025), 65, w * (x + .05), 72)
        ..lineTo(w * (x + .05), baseline);
      canvas.drawPath(arch, paint);
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant _MosquePainter oldDelegate) => false;
}
