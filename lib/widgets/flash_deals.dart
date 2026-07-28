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
  Duration _remaining = const Duration(hours: 16, minutes: 11, seconds: 4);

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
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.flashDealBg, AppColors.flashDealBgEnd],
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(Layout.s18, Layout.s12, Layout.s12, 6),
            child: Row(
              children: <Widget>[
                const Icon(Icons.timer_outlined, color: AppColors.orange, size: 22),
                const SizedBox(width: Layout.s4),
                const Expanded(
                  child: Text('Deposito Flash Deals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic)),
                ),
                const Text('Dimulai\ndalam', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Color(0xFF707070), height: 1.0)),
                const SizedBox(width: Layout.s4),
                _clock(h, 'JAM'),
                const SizedBox(width: 2),
                _clock(m, 'MNT'),
                const SizedBox(width: 2),
                _clock(s, 'DTK'),
              ],
            ),
          ),
          SizedBox(
            height: 190,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(width: 130, child: _intro()),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: Layout.s12),
                    itemCount: MockData.flashDeals.length,
                    separatorBuilder: (_, __) => const SizedBox(width: Layout.s8),
                    itemBuilder: (_, int index) => _deal(MockData.flashDeals[index]),
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
          width: 28, height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.clockBg, borderRadius: BorderRadius.circular(3)),
          child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        ),
        const SizedBox(height: 1),
        Text(label, style: const TextStyle(fontSize: 7, color: Color(0xFF777777))),
      ],
    );
  }

  Widget _intro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Layout.s14, Layout.s8, 6, 0),
      child: Stack(
        children: <Widget>[
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Jangan\nLewatkan 🔥', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.1)),
              SizedBox(height: Layout.s4),
              Text('Penawaran terbatas\ndimulai pada ', style: TextStyle(fontSize: 12, color: Color(0xFF5F5F5F), height: 1.2)),
              Text('Jumat\n7:00 PM', style: TextStyle(fontSize: 13, color: AppColors.orange, fontWeight: FontWeight.w700, height: 1.2)),
            ],
          ),
          Positioned(
            bottom: Layout.s8,
            left: Layout.s4,
            child: Icon(Icons.local_fire_department_rounded, color: AppColors.orange.withOpacity(0.1), size: 60),
          ),
        ],
      ),
    );
  }

  Widget _deal(DepositPromotion item) {
    return SizedBox(
      width: 120,
      child: SoftCard(
        radius: Layout.cardRadiusXs,
        padding: const EdgeInsets.fromLTRB(Layout.s10, Layout.s8, Layout.s10, Layout.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.term, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: Layout.s4),
            Text(item.rate, style: const TextStyle(color: AppColors.orange, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: Layout.s2),
            Text(item.previousRate, style: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 11, decoration: TextDecoration.lineThrough)),
            const SizedBox(height: Layout.s2),
            Text(item.quota, style: const TextStyle(color: AppColors.orange, fontSize: 11)),
            const Spacer(),
            AppTextButton(label: 'Ingatkan', onTap: () {}, filled: false, height: 30),
          ],
        ),
      ),
    );
  }
}
