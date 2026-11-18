import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/insurance_product.dart';
import 'product_card.dart';
import 'section_title.dart';

const List<InsuranceProduct> _products = [
  InsuranceProduct(
    id: 'auto',
    label: 'Automóvel',
    icon: Icons.directions_car_outlined,
  ),
  InsuranceProduct(id: 'home', label: 'Residência', icon: Icons.house_outlined),
  InsuranceProduct(id: 'life', label: 'Vida', icon: Icons.favorite_outline),
  InsuranceProduct(
    id: 'accident',
    label: 'Acidentes Pessoais',
    icon: Icons.healing_outlined,
  ),
];

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  Future<void> _onProductTap(
    BuildContext context,
    InsuranceProduct product,
  ) async {
    if (product.id == 'auto') {
      if (kIsWeb) {
        await launchUrl(
          Uri.parse(AppConstants.webViewUrl),
          webOnlyWindowName: '_blank',
        );
      } else {
        if (context.mounted) {
          context.push(AppRoutes.auto, extra: AppConstants.webViewUrl);
        }
      }
      return;
    }
    context.push(AppRoutes.quote, extra: product.label);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: SectionTitle('Cotar e Contratar'),
        ),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: _products.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductCard(
                product: product,
                onTap: () => _onProductTap(context, product),
              );
            },
          ),
        ),
      ],
    );
  }
}
