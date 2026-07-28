import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../models/promotion.dart';
import '../services/mock_data.dart';
import 'common.dart';

/// Flash Deals countdown timer + deposit promo cards.
class FlashDeals extends StatefulWidget {
  const FlashDeals({super.key});

  @override
  State<FlashDeals> createState() => _FlashDealsState();
}

class _FlashDealsState extends State<FlashDeals> {
  late Timer _timer;
  Duration _remaining =
      const Duration(hours: 16, minutes: 11, seconds: 4);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _remaining.inSeconds == 0
            ? const Duration(hours: 16, minutes: 11, seconds: 4)
            : _remaining - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final String h = _pad(_remaining.inHours);
    final String m = _pad(_remaining.inMinutes.remainder(60));
    final String s = _pad(_remaining.inSeconds.remainder(60));

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.flashDealBg,
            AppColors.flashDealBgEnd,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          // ── Header with timer ────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.fromLTRB(Layout.spacingXxl, 18, 18, 9),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.timer_outlined,
                  color: AppColors.orange,
                  size: 30,
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Deposito Flash Deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Text(
                  'Dimulai\ndalam',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF707070),
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 7),
                _clock(h, 'JAM'),
                const SizedBox(width: 3),
                _clock(m, 'MNT'),
                const SizedBox(width: 3),
                _clock(s, 'DTK'),
              ],
            ),
          ),
          // ── Deals cards ──────────────────────────────────────
          SizedBox(
            height: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(width: 155, child: _intro()),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 18),
                    itemCount: MockData.flashDeals.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: Layout.spacingMd),
                    itemBuilder: (_, int index) =>
                        _deal(MockData.flashDeals[index]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _clock(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 35,
          height: 37,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.clockBg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 19,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFF777777),
          ),
        ),
      ],
    );
  }

  Widget _intro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, Layout.spacingMd, 7, 0),
      child: Stack(
        children: <Widget>[
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Jangan\nLewatkan 🔥',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Penawaran terbatas\ndimulai pada ',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5F5F5F),
                  height: 1.25,
                ),
              ),
              Text(
                'Jumat\n7:00 PM',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.orange,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: Layout.spacingMd,
            left: Layout.spacingSm,
            child: Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.orange.withOpacity(0.12),
              size: 78,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deal(DepositPromotion item) {
    return SizedBox(
      width: 142,
      child: SoftCard(
        radius: Layout.cardRadiusXs,
        padding: const EdgeInsets.fromLTRB(
            Layout.spacingMd, 10, Layout.spacingMd, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.term,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.rate,
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.previousRate,
              style: const TextStyle(
                color: Color(0xFF9D9D9D),
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.quota,
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            AppTextButton(
              label: 'Ingatkan',
              onTap: () {},
              filled: false,
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
