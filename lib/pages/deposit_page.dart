import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

/// Deposito page showing promo hero, flash deals, deposit options, and FAQ.
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
            padding: const EdgeInsets.fromLTRB(
              Layout.pagePaddingWide,
              Layout.spacingXl,
              Layout.pagePaddingWide,
              28,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                const Text(
                  'Deposito',
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _hero(),
                const SizedBox(height: 19),
                const FlashDeals(),
                const SizedBox(height: 25),
                _depositList(context),
                const SizedBox(height: 25),
                _faq(context),
                const SizedBox(height: 26),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Hero
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _hero() {
    return Container(
      height: 210,
      padding: const EdgeInsets.fromLTRB(20, 16, Layout.spacingMd, Layout.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.depositHeroStart,
            AppColors.depositHeroEnd,
          ],
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
                  Text(
                    'Pilihan\nDeposito\nUntukmu',
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange,
                      height: 1.12,
                    ),
                  ),
                  SizedBox(height: 17),
                  Text(
                    'Tumbuhkan dana dan dapatkan\nkeuntungan maksimal!',
                    style: TextStyle(
                      color: AppColors.hintOrange,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: Layout.spacingMd,
                  child: Container(
                    width: 94,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      size: 54,
                      color: AppColors.orange,
                    ),
                  ),
                ),
                const Positioned(
                  right: 2,
                  bottom: 2,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.circleBlue,
                    child: Icon(
                      Icons.schedule_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 25,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.gold,
                    child: Icon(
                      Icons.attach_money_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Deposit List
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _depositList(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(
        Layout.spacingXxl,
        23,
        Layout.spacingXxl,
        13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Deposito Lainnya',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          _depositRow(context, 'Deposito SeaBank', 'Hingga 6% p.a'),
          const Divider(height: 29),
          _depositRow(
            context,
            'Deposito Cashback Xtra',
            'Cashback hingga\nRp161.300.000',
          ),
        ],
      ),
    );
  }

  Widget _depositRow(
      BuildContext context, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Layout.spacingSm),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 148,
          child: AppTextButton(
            label: 'Buka Deposito',
            onTap: () => _openDeposit(context),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  FAQ
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _faq(BuildContext context) {
    const List<String> items = <String>[
      'Berapa Bunga dan tenor Deposito SeaBank?',
      'Apa itu Produk Deposito Berjangka SeaBank?',
      'Bagaimana cara membuka Deposito?',
    ];

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(
        Layout.spacingXxl,
        22,
        Layout.spacingXxl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Pertanyaan Umum',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (String item) => _faqItem(context, item),
          ),
          InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Menampilkan seluruh pertanyaan umum'),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Lihat lebih banyak',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                    ),
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
          title: Text(item),
          content: const Text(
            'Informasi deposito tersedia langsung di aplikasi. '
            'Suku bunga dan ketentuan dapat berubah sesuai program yang berlaku.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 19),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.line),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                item,
                style: const TextStyle(fontSize: 18, height: 1.3),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
            ),
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
        padding: const EdgeInsets.fromLTRB(
          Layout.spacingXxl,
          0,
          Layout.spacingXxl,
          32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Buka Deposito',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih tenor dan nominal deposito Anda pada langkah berikutnya.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: AppTextButton(
                label: 'Mulai',
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
