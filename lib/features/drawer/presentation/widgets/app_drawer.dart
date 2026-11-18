import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';

class _MenuItem {
  const _MenuItem(this.label, this.route);

  final String label;
  final String route;
}

const List<_MenuItem> _menuItems = [
  _MenuItem('Home / Seguros', AppRoutes.home),
  _MenuItem('Minhas Contratações', AppRoutes.contracts),
  _MenuItem('Meus Sinistros', AppRoutes.claims),
  _MenuItem('Minha Família', AppRoutes.family),
  _MenuItem('Meus Bens', AppRoutes.assets),
  _MenuItem('Pagamentos', AppRoutes.payments),
  _MenuItem('Coberturas', AppRoutes.coverages),
  _MenuItem('Validar Boleto', AppRoutes.validateBill),
  _MenuItem('Telefones Importantes', AppRoutes.phones),
  _MenuItem('Configurações', AppRoutes.settings),
];

const double _horizontalPadding = 20;

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = math.min(MediaQuery.sizeOf(context).width * 0.72, 304.0);
    return Drawer(
      width: width,
      shape: const RoundedRectangleBorder(),
      child: const _NavigationPanel(),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  const _NavigationPanel();

  void _go(BuildContext context, String route) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    if (GoRouterState.of(context).uri.path != route) {
      context.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              children: [
                const _DrawerHeader(),
                const SizedBox(height: 20),
                for (final item in _menuItems)
                  _MenuTile(
                    label: item.label,
                    onTap: () => _go(context, item.route),
                  ),
                InkWell(
                  onTap: () => context.read<SessionCubit>().signOut(),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(
                      _horizontalPadding,
                      12,
                      _horizontalPadding,
                      8,
                    ),
                    child: Text(
                      'Sair',
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const _HelpBanner(),
      ],
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Olá!', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              const _BadgedAvatar(
                radius: 18,
                icon: Icons.person,
                badgeColor: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocSelector<SessionCubit, SessionState, String>(
                      selector: (state) => state.user?.name ?? '',
                      builder: (context, name) => Text(
                        name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Minha conta',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            const Icon(Icons.settings, color: AppColors.primary, size: 20),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}

class _BadgedAvatar extends StatelessWidget {
  const _BadgedAvatar({
    required this.radius,
    required this.icon,
    required this.badgeColor,
  });

  final double radius;
  final IconData icon;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.surfaceLight,
          child: Icon(icon, color: AppColors.textSecondary, size: radius),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            width: radius * 0.6,
            height: radius * 0.6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpBanner extends StatelessWidget {
  const _HelpBanner();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BadgedAvatar(
            radius: 18,
            icon: Icons.support_agent,
            badgeColor: AppColors.accent,
          ),
          SizedBox(height: 6),
          Text(
            'Dúvidas?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Converse agora mesmo com a Marina\ne tire suas dúvidas agora mesmo!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10, height: 1.3),
          ),
        ],
      ),
    );
  }
}
