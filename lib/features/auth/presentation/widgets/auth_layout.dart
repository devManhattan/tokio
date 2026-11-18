import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'auth_card.dart';
import 'auth_header.dart';

const double _minHeight = 560;
const double _headerHeightFactor = 0.5;
const double _cardTopFactor = 0.28;
const double _actionOverlap = 38;

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cardMinHeightFactor,
    required this.child,
    this.action,
    this.footer,
  });

  final String title;
  final String subtitle;
  final double cardMinHeightFactor;
  final Widget child;
  final Widget? action;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final height = math.max(
      MediaQuery.sizeOf(context).height -
          MediaQuery.paddingOf(context).vertical,
      _minHeight,
    );
    final action = this.action;

    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: IntrinsicHeight(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AuthHeader(
                  height: height * _headerHeightFactor,
                  title: title,
                  subtitle: subtitle,
                ),
                Column(
                  children: [
                    SizedBox(height: height * _cardTopFactor),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: AuthCard(
                        minHeight: height * cardMinHeightFactor,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: action == null ? 0 : _actionOverlap,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                    if (action != null)
                      Transform.translate(
                        offset: const Offset(0, -_actionOverlap),
                        child: action,
                      ),
                    const Spacer(),
                    footer ?? const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
