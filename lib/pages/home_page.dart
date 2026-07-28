import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../core/utils/currency.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

/// Main Beranda / Home screen showing balance card, quick actions & promos.
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
            padding: const EdgeInsets.fromLTRB(
              Layout.pagePadding,
              18,
              Layout.pagePadding,
              24,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _header(context, ref, state),
                const SizedBox(height: 38),
                _balanceCard(context, ref, state),
                const SizedBox(height: 22),
                _quickActions(context),
                const SizedBox(height: 23),
                const FlashDeals(),
                const SizedBox(height: 23),
                _banner(),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Header
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _header(BuildContext context, WidgetRef ref, AppState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const UserAvatar(size: Layout.avatarSizeLg),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  state.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkDark,
                  ),
                ),
                const SizedBox(height: Layout.spacingSm),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'No. Rekening: ${state.accountNumber}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.mutedLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: Layout.spacingSm),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Nomor rekening disalin'),
                      )),
                      child: const Icon(
                        Icons.copy_outlined,
                        size: 23,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Layout.spacingSm),
        const NotificationButton(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Balance Card
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _balanceCard(
      BuildContext context, WidgetRef ref, AppState state) {
    return Container(
      height: 372,
      padding: const EdgeInsets.fromLTRB(28, 32, 26, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Layout.cardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.orangeGradientStart,
            AppColors.orangeGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // ── Decorative icon ──────────────────────────────────
          Positioned(
            right: -65,
            top: -78,
            child: Icon(
              Icons.currency_exchange_rounded,
              color: Colors.white.withOpacity(0.08),
              size: 330,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── Title row ──────────────────────────────────
              Row(
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Total Saldo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 7),
                          InkWell(
                            onTap: () => ref
                                .read(appStateProvider.notifier)
                                .setBalanceHidden(
                                    !state.isBalanceHidden),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                state.isBalanceHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Material(
                      color: const Color(0xFFCF4D00),
                      borderRadius: BorderRadius.circular(26),
                      child: InkWell(
                        onTap: () => context.go('/transfer'),
                        borderRadius: BorderRadius.circular(26),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 11,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Riwayat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ── Balance amount ────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  visibleMoney(state, state.balance),
                  key: ValueKey<String>(
                      '${state.isBalanceHidden}-${state.balance}'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.0,
                    height: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.28),
              ),
              const SizedBox(height: 30),
              // ── Savings & Deposit rows ────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _accountColumn(
                      context,
                      'Tabungan',
                      visibleMoney(state, state.savingsBalance),
                      '2,5% p.a. cair harian',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _depositColumn(context, state),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accountColumn(
    BuildContext context,
    String title,
    String amount,
    String sub,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 21),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: Layout.spacingSm),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            sub,
            style: const TextStyle(
              color: Color(0xFFFFD2AF),
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _depositColumn(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Deposito',
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                visibleMoney(state, 0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => context.go('/deposit'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD19A),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text(
                    'Buka Deposito',
                    style: TextStyle(
                      color: Color(0xFF713600),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Layout.spacingSm),
        const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Hingga 6% p.a.',
            style: TextStyle(
              color: Color(0xFFFFD2AF),
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Quick Actions
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _quickActions(BuildContext context) {
    const List<_QuickAction> actions = <_QuickAction>[
      _QuickAction(
          'Transfer', Icons.swap_horiz_rounded, '/transfer'),
      _QuickAction(
          'Top Up &\nTagihan', Icons.receipt_long_rounded, '/transfer'),
      _QuickAction(
          'Top Up\nE-Wallet',
          Icons.account_balance_wallet_rounded,
          '/transfer',
          badge: 'Baru'),
      _QuickAction(
          'Undang\nTeman', Icons.group_rounded, '/profile'),
      _QuickAction('Deposito', Icons.savings_rounded, '/deposit'),
      _QuickAction(
          'Tarik Tunai',
          Icons.download_rounded,
          null,
          badge: 'Gratis 7x'),
      _QuickAction(
          'Pinjaman',
          Icons.volunteer_activism_rounded,
          null),
      _QuickAction(
          'Lihat Semua', Icons.more_horiz_rounded, null),
    ];

    return SoftCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 25,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 150,
        ),
        itemBuilder: (_, int index) =>
            _quickAction(context, actions[index]),
      ),
    );
  }

  Widget _quickAction(
      BuildContext context, _QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (action.route != null) {
            context.go(action.route!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${action.label.replaceAll('\n', ' ')} dipilih'),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(14),
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
                  child: Icon(
                    action.icon,
                    color: AppColors.orange,
                    size: 32,
                  ),
                ),
                if (action.badge != null)
                  Positioned(
                    right: -24,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.badgeBg,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        action.badge!,
                        style: const TextStyle(
                          color: AppColors.badgeText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Layout.spacingMd),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                color: AppColors.subtitle,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Banner
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _banner() {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(Layout.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(Layout.cardRadiusSm),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.workspace_premium_rounded,
            size: 54,
            color: Color(0xFFFF9800),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'BUNGA DEPOSITO SPESIAL\nUntuk masa depan yang lebih pasti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.route, {this.badge});

  final String label;
  final IconData icon;
  final String? route;
  final String? badge;
}
