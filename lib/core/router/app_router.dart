import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auto/presentation/pages/auto_webview_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/placeholder/presentation/pages/placeholder_page.dart';
import '../constants/app_constants.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.login}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.auto,
      builder: (context, state) => AutoWebViewPage(
        url: state.extra as String? ?? AppConstants.webViewUrl,
      ),
    ),
    GoRoute(
      path: AppRoutes.quote,
      builder: (context, state) {
        final product = state.extra as String?;
        return PlaceholderPage(
          title: product == null ? 'Cotação' : 'Cotar $product',
          message: 'Fluxo de cotação em construção.',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.contracts,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Minhas Contratações'),
    ),
    GoRoute(
      path: AppRoutes.claims,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Meus Sinistros'),
    ),
    GoRoute(
      path: AppRoutes.family,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Minha Família'),
    ),
    GoRoute(
      path: AppRoutes.assets,
      builder: (context, state) => const PlaceholderPage(title: 'Meus Bens'),
    ),
    GoRoute(
      path: AppRoutes.payments,
      builder: (context, state) => const PlaceholderPage(title: 'Pagamentos'),
    ),
    GoRoute(
      path: AppRoutes.coverages,
      builder: (context, state) => const PlaceholderPage(title: 'Coberturas'),
    ),
    GoRoute(
      path: AppRoutes.validateBill,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Validar Boleto'),
    ),
    GoRoute(
      path: AppRoutes.phones,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Telefones Importantes'),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) =>
          const PlaceholderPage(title: 'Configurações'),
    ),
  ],
);
