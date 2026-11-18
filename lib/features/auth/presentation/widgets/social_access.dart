import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SocialAccess extends StatelessWidget {
  const SocialAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TokioResolveMark(),
        SizedBox(height: AppSpacing.md),
        Text(
          'Acesse através das redes sociais',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialGlyph(child: Text('G', style: _glyphStyle)),
            SizedBox(width: AppSpacing.xl),
            _SocialGlyph(
              child: Icon(Icons.facebook, color: Colors.white, size: 28),
            ),
            SizedBox(width: AppSpacing.xl),
            _SocialGlyph(
              child: Icon(Icons.flutter_dash, color: Colors.white, size: 28),
            ),
          ],
        ),
      ],
    );
  }

  static const TextStyle _glyphStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
}

class _SocialGlyph extends StatelessWidget {
  const _SocialGlyph({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 30, height: 30, child: Center(child: child));
  }
}

class _TokioResolveMark extends StatelessWidget {
  const _TokioResolveMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _Blob(color: AppColors.accent),
              ),
              Align(
                alignment: Alignment.topRight,
                child: _Blob(color: AppColors.primary),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: _Blob(color: Color(0xFF3B82F6)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('tokio ', style: TextStyle(color: AppColors.textPrimary)),
            Text(
              'resolve',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.amber[400],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
    );
  }
}
