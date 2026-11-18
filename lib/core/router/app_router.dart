import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auto/presentation/pages/auto_webview_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/placeholder/presentation/pages/placeholder_page.dart';
import '../constants/app_constants.dart';
import 'app_routes.dart';
import 'stream_listenable.dart';

const Set<String> _publicRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

class AppRouter {
  AppRouter({
    required SessionCubit session,
    String initialLocation = AppRoutes.login,
  }) : _session = session,
       _refresh = StreamListenable(session.stream) {
    config = GoRouter(
      initialLocation: initialLocation,
      refreshListenable: _refresh,
      redirect: (context, state) => _redirect(state.matchedLocation),
      routes: _routes,
    );
  }

  final SessionCubit _session;
  final StreamListenable _refresh;
  late final GoRouter config;

  void dispose() {
    config.dispose();
    _refresh.dispose();
  }

  String? _redirect(String location) {
    final status = _session.state.status;
    if (status == SessionStatus.unknown) return null;

    final isPublic = _publicRoutes.contains(location);
    final isAuthenticated = status == SessionStatus.authenticated;
    if (!isAuthenticated && !isPublic) return AppRoutes.login;
    if (isAuthenticated && isPublic) return AppRoutes.home;
    return null;
  }
}

final List<RouteBase> _routes = [
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
  GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
  GoRoute(
    path: AppRoutes.auto,
    builder: (context, state) =>
        AutoWebViewPage(url: state.extra as String? ?? AppConstants.webViewUrl),
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
    builder: (context, state) => const PlaceholderPage(title: 'Meus Sinistros'),
  ),
  GoRoute(
    path: AppRoutes.family,
    builder: (context, state) => const PlaceholderPage(title: 'Minha Família'),
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
    builder: (context, state) => const PlaceholderPage(title: 'Validar Boleto'),
  ),
  GoRoute(
    path: AppRoutes.phones,
    builder: (context, state) =>
        const PlaceholderPage(title: 'Telefones Importantes'),
  ),
  GoRoute(
    path: AppRoutes.settings,
    builder: (context, state) => const PlaceholderPage(title: 'Configurações'),
  ),
];
