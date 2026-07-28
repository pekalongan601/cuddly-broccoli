import 'dart:math';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';

/// QRIS scanner screen with corner decorations, scan-line animation,
/// and bottom actions (flash, show QR, gallery).
class QrisPage extends StatefulWidget {
  const QrisPage({super.key});

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // ── Background gradient ────────────────────────────
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.1),
                    radius: 0.95,
                    colors: <Color>[
                      AppColors.qrisBg,
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            // ── Top bar ────────────────────────────────────────
            Positioned(
              top: 22,
              left: 26,
              right: 26,
              child: Row(
                children: <Widget>[
                  IconButton(
                    constraints:
                        const BoxConstraints.tightFor(width: 42, height: 42),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: Layout.spacingSm),
                  const Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Scan QRIS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── QR viewfinder ──────────────────────────────────
            Center(
              child: Builder(
                builder: (BuildContext context) {
                  final Size size = MediaQuery.sizeOf(context);
                  final double verticalAllowance =
                      size.height < 500 ? 164.0 : 262.0;
                  final double square = min(
                    size.width - 72,
                    size.height - verticalAllowance,
                  ).clamp(180.0, 420.0);

                  return SizedBox(
                    width: square,
                    height: square,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                            painter: const _CornerPainter(),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder:
                              (BuildContext context, Widget? child) {
                            return Positioned(
                              left: 24,
                              right: 24,
                              top: 42 +
                                  (square - 84) *
                                      _controller.value,
                              child: Container(
                                height: 1.5,
                                decoration: BoxDecoration(
                                  color: AppColors.orange
                                      .withOpacity(0.65),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: AppColors.orange
                                          .withOpacity(0.6),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // ── Label below viewfinder ─────────────────────────
            const Align(
              alignment: Alignment(0, 0.2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Scan Kode ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.qr_code_2_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ],
              ),
            ),
            // ── Bottom actions ─────────────────────────────────
            Positioned(
              left: 32,
              right: 32,
              bottom:
                  MediaQuery.sizeOf(context).height < 500 ? 18 : 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _action(
                    _flashOn
                        ? Icons.flashlight_on_rounded
                        : Icons.flashlight_on_outlined,
                    'Flash',
                    () => setState(() => _flashOn = !_flashOn),
                    active: _flashOn,
                  ),
                  _action(
                    Icons.qr_code_2_rounded,
                    'Tampilkan QR',
                    () => _showQr(context),
                  ),
                  _action(
                    Icons.photo_outlined,
                    'Galeri',
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih kode QR dari galeri'),
                      ),
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

  Widget _action(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Layout.cardRadiusXs),
      child: SizedBox(
        width: label == 'Tampilkan QR' ? 130 : 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: active ? AppColors.orange : Colors.white,
              size: 39,
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: active ? AppColors.orange : Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQr(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(
          Layout.spacingXxl,
          0,
          Layout.spacingXxl,
          36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'QR Saya',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            _QrPlaceholder(),
            SizedBox(height: 16),
            Text(
              'Tunjukkan kode ini untuk menerima pembayaran',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF676767)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  QR placeholder widget
// ═══════════════════════════════════════════════════════════════════════════════

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      width: 205,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Icon(
        Icons.qr_code_2_rounded,
        color: Colors.white,
        size: 190,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Corner painter for QR viewfinder
// ═══════════════════════════════════════════════════════════════════════════════

class _CornerPainter extends CustomPainter {
  const _CornerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double stroke = 5.0;
    const double length = 38.0;
    const double inset = 4.0;

    final Paint paint = Paint()
      ..color = AppColors.qrisCorner
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;

    // Top-left
    canvas.drawLine(
        const Offset(inset, inset),
        const Offset(inset + length, inset), paint);
    canvas.drawLine(
        const Offset(inset, inset),
        const Offset(inset, inset + length), paint);

    // Top-right
    canvas.drawLine(
        Offset(size.width - inset, inset),
        Offset(size.width - inset - length, inset), paint);
    canvas.drawLine(
        Offset(size.width - inset, inset),
        Offset(size.width - inset, inset + length), paint);

    // Bottom-left
    canvas.drawLine(
        Offset(inset, size.height - inset),
        Offset(inset + length, size.height - inset), paint);
    canvas.drawLine(
        Offset(inset, size.height - inset),
        Offset(inset, size.height - inset - length), paint);

    // Bottom-right
    canvas.drawLine(
        Offset(size.width - inset, size.height - inset),
        Offset(size.width - inset - length, size.height - inset),
        paint);
    canvas.drawLine(
        Offset(size.width - inset, size.height - inset),
        Offset(size.width - inset, size.height - inset - length),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      false;
}
