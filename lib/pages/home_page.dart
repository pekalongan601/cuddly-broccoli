import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../core/utils/currency.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

/// Main Beranda / Home screen.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        key: const PageStorageKey('home-scroll'),
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Layout.pagePadding, 14, Layout.pagePadding, 18),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _header(context, ref, state),
                const SizedBox(height: Layout.s20),
                _balanceCard(context, ref, state),
                const SizedBox(height: Layout.s14),
                _quickActions(context),
                const SizedBox(height: Layout.s16),
                const FlashDeals(),
                const SizedBox(height: Layout.s16),
                _banner(),
                const SizedBox(height: Layout.s20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref, AppState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const UserAvatar(size: Layout.avatarSizeLg),
        const SizedBox(width: Layout.s10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                state.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: Layout.fsName, fontWeight: FontWeight.w600, color: AppColors.inkDark),
              ),
              const SizedBox(height: Layout.s4),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'No. Rekening: ${state.accountNumber}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: Layout.fsAccount, color: AppColors.mutedLight),
                    ),
                  ),
                  const SizedBox(width: Layout.s4),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nomor rekening disalin')),
                    ),
                    child: const Icon(Icons.copy_outlined, size: 16, color: AppColors.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: Layout.s4),
        const NotificationButton(),
      ],
    );
  }

  Widget _balanceCard(BuildContext context, WidgetRef ref, AppState state) {
    return Container(
      height: Layout.balanceCardHeight,
      padding: const EdgeInsets.fromLTRB(Layout.balanceCardPaddingH, Layout.balanceCardPaddingV, Layout.balanceCardPaddingH, Layout.balanceCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Layout.cardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -48,
            top: -56,
            child: Icon(
              Icons.currency_exchange_rounded,
              color: Colors.white.withOpacity(0.08),
              size: 240,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Total Saldo', style: TextStyle(color: Colors.white, fontSize: Layout.fsBalanceLabel, fontWeight: FontWeight.w500)),
                        const SizedBox(width: Layout.s4),
                        InkWell(
                          onTap: () => ref.read(appStateProvider.notifier).setBalanceHidden(!state.isBalanceHidden),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Icon(
                              state.isBalanceHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.white,
                              size: Layout.iconEye,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Layout.s4),
                  Material(
                    color: AppColors.riwayatBg,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => context.go('/transfer'),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Riwayat', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Layout.s12),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    visibleMoney(state, state.balance),
                    key: ValueKey<String>('${state.isBalanceHidden}-${state.balance}'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Layout.fsBalance,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(height: 1, color: Colors.white.withOpacity(0.22)),
              const SizedBox(height: Layout.s18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: _accountColumn('Tabungan', visibleMoney(state, state.savingsBalance), '2,5% p.a. cair harian')),
                  const SizedBox(width: Layout.s12),
                  Expanded(child: _depositColumn(state)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accountColumn(String title, String amount, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: const TextStyle(color: Colors.white, fontSize: Layout.fsCardTitle)),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: Layout.iconChevron),
          ],
        ),
        const SizedBox(height: Layout.s8),
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: Layout.fsCardAmount, fontWeight: FontWeight.w600)),
        const SizedBox(height: Layout.s4),
        Text(sub, style: const TextStyle(color: AppColors.savingsSubText, fontSize: Layout.fsCardSub)),
      ],
    );
  }

  Widget _depositColumn(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Deposito', style: TextStyle(color: Colors.white, fontSize: Layout.fsCardTitle)),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: Layout.iconChevron),
          ],
        ),
        const SizedBox(height: Layout.s8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(visibleMoney(state, 0), style: const TextStyle(color: Colors.white, fontSize: Layout.fsCardAmount, fontWeight: FontWeight.w600)),
            const SizedBox(width: Layout.s4),
            InkWell(
              onTap: () => context.go('/deposit'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.depositCtaBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Buka Deposito', style: TextStyle(color: AppColors.depositCtaText, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: Layout.s4),
        const Text('Hingga 6% p.a.', style: TextStyle(color: AppColors.savingsSubText, fontSize: Layout.fsCardSub)),
      ],
    );
  }

  Widget _quickActions(BuildContext context) {
    const List<_QuickAction> actions = <_QuickAction>[
      _QuickAction('Transfer', Icons.swap_horiz_rounded, '/transfer'),
      _QuickAction('Top Up &\nTagihan', Icons.receipt_long_rounded, '/transfer'),
      _QuickAction('Top Up\nE-Wallet', Icons.account_balance_wallet_rounded, '/transfer', badge: 'Baru'),
      _QuickAction('Undang\nTeman', Icons.group_rounded, '/profile'),
      _QuickAction('Deposito', Icons.savings_rounded, '/deposit'),
      _QuickAction('Tarik Tunai', Icons.download_rounded, null, badge: 'Gratis 7x'),
      _QuickAction('Pinjaman', Icons.volunteer_activism_rounded, null),
      _QuickAction('Lihat Semua', Icons.more_horiz_rounded, null),
    ];

    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 110,
        ),
        itemBuilder: (_, int index) => _quickAction(context, actions[index]),
      ),
    );
  }

  Widget _quickAction(BuildContext context, _QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (action.route != null) {
            context.go(action.route!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${action.label.replaceAll('\n', ' ')} dipilih')),
            );
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: Layout.actionIconSize,
                  height: Layout.actionIconSize,
                  alignment: Alignment.center,
                  child: Icon(action.icon, color: AppColors.orange, size: Layout.iconAction),
                ),
                if (action.badge != null)
                  Positioned(
                    right: -18,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.badgeBg, borderRadius: BorderRadius.circular(5)),
                      child: Text(action.badge!, style: const TextStyle(color: AppColors.badgeText, fontWeight: FontWeight.w600, fontSize: 9)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Layout.s6),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: Layout.fsActionLabel, color: AppColors.subtitle, height: 1.15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _banner() {
    return Container(
      height: 84,
      padding: const EdgeInsets.all(Layout.s14),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(Layout.cardRadiusSm),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.workspace_premium_rounded, size: 42, color: Color(0xFFFF9800)),
          SizedBox(width: Layout.s10),
          Expanded(
            child: Text(
              'BUNGA DEPOSITO SPESIAL\nUntuk masa depan yang lebih pasti',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.route, {this.badge});
  final String label;
  final IconData icon;
  final String? route;
  final String? badge;
}
