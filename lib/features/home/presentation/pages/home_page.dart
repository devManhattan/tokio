import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../../drawer/presentation/widgets/app_drawer.dart';
import '../widgets/info_section.dart';
import '../widgets/quote_section.dart';
import '../widgets/section_title.dart';
import '../widgets/user_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const _MenuIcon(),
          ),
        ),
        title: const BrandLogo(fontSize: 11),
        actions: const [NotificationBell()],
      ),
      body: const _HomeContent(),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  const _MenuIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuLine(width: 22),
          SizedBox(height: 5),
          _MenuLine(width: 14),
          SizedBox(height: 5),
          _MenuLine(width: 18),
        ],
      ),
    );
  }
}

class _MenuLine extends StatelessWidget {
  const _MenuLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<SessionCubit, SessionState, String>(
            selector: (state) => state.user?.name ?? '',
            builder: (context, name) => UserBanner(name: name),
          ),
          const QuoteSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Minha Família'),
                InfoSection(
                  icon: Icons.add_circle_outline,
                  message: 'Adicione aqui membros da sua família e compartilhe os seguros com eles.',
                  onTap: () => context.push(AppRoutes.family),
                ),
                const SectionTitle('Contratados'),
                const InfoSection(
                  icon: Icons.sentiment_dissatisfied_outlined,
                  message: 'Você ainda não possui seguros contratados.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
