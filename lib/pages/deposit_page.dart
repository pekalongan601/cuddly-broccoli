import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

/// Deposito page.
class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        key: const PageStorageKey('deposit-scroll'),
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Layout.pagePaddingWide, Layout.s14, Layout.pagePaddingWide, 22),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                const Text('Deposito', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(height: Layout.s14),
                _hero(),
                const SizedBox(height: Layout.s14),
                const FlashDeals(),
                const SizedBox(height: Layout.s18),
                _depositList(context),
                const SizedBox(height: Layout.s18),
                _faq(context),
                const SizedBox(height: Layout.s20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(16, Layout.s12, Layout.s10, Layout.s10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.depositHeroStart, AppColors.depositHeroEnd],
        ),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: FittedBox(
              alignment: Alignment.topLeft,
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Pilihan\nDeposito\nUntukmu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.orange, height: 1.1)),
                  SizedBox(height: Layout.s10),
                  Text('Tumbuhkan dana dan dapatkan\nkeuntungan maksimal!', style: TextStyle(color: AppColors.hintOrange, fontSize: 13, height: 1.25)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: Layout.s8,
                  child: Container(
                    width: 74, height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.savings_rounded, size: 40, color: AppColors.orange),
                  ),
                ),
                const Positioned(right: 4, bottom: 2, child: CircleAvatar(radius: 22, backgroundColor: AppColors.circleBlue, child: Icon(Icons.schedule_rounded, color: Colors.white, size: 28))),
                const Positioned(top: 6, right: 20, child: CircleAvatar(radius: 10, backgroundColor: AppColors.gold, child: Icon(Icons.attach_money_rounded, size: 16, color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _depositList(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(Layout.s20, 18, Layout.s20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Deposito Lainnya', style: TextStyle(fontSize: Layout.fsSectionTitle, fontWeight: FontWeight.w600)),
          const SizedBox(height: Layout.s14),
          _depositRow(context, 'Deposito SeaBank', 'Hingga 6% p.a'),
          const Divider(height: 22),
          _depositRow(context, 'Deposito Cashback Xtra', 'Cashback hingga\nRp161.300.000'),
        ],
      ),
    );
  }

  Widget _depositRow(BuildContext context, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: const TextStyle(color: AppColors.orange, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: Layout.s4),
              Text(subtitle, style: const TextStyle(fontSize: Layout.fsBody, height: 1.25)),
            ],
          ),
        ),
        const SizedBox(width: Layout.s8),
        SizedBox(
          width: 120,
          child: AppTextButton(label: 'Buka Deposito', onTap: () => _openDeposit(context), height: 34),
        ),
      ],
    );
  }

  Widget _faq(BuildContext context) {
    const List<String> items = <String>[
      'Berapa Bunga dan tenor Deposito SeaBank?',
      'Apa itu Produk Deposito Berjangka SeaBank?',
      'Bagaimana cara membuka Deposito?',
    ];

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(Layout.s20, 18, Layout.s20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Pertanyaan Umum', style: TextStyle(fontSize: Layout.fsSectionTitle, fontWeight: FontWeight.w600)),
          const SizedBox(height: Layout.s10),
          ...items.map((String item) => _faqItem(context, item)),
          InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menampilkan seluruh pertanyaan umum'))),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: Layout.s16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Lihat lebih banyak', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                    SizedBox(width: Layout.s4),
                    Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqItem(BuildContext context, String item) {
    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(item, style: const TextStyle(fontSize: 16)),
          content: const Text('Informasi deposito tersedia langsung di aplikasi. Suku bunga dan ketentuan dapat berubah sesuai program yang berlaku.', style: TextStyle(fontSize: 14)),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mengerti', style: TextStyle(fontSize: 14))),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Layout.s14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(item, style: const TextStyle(fontSize: Layout.fsBody, height: 1.25))),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }

  void _openDeposit(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(Layout.s20, 0, Layout.s20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Buka Deposito', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: Layout.s8),
            const Text('Pilih tenor dan nominal deposito Anda pada langkah berikutnya.', style: TextStyle(fontSize: 14)),
            const SizedBox(height: Layout.s14),
            SizedBox(width: double.infinity, child: AppTextButton(label: 'Mulai', onTap: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}
