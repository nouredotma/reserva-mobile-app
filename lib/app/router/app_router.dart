import 'package:go_router/go_router.dart';
import 'package:reservamobile/features/booking/presentation/booking_screen.dart';
import 'package:reservamobile/features/detail/presentation/detail_screen.dart';
import 'package:reservamobile/features/auth/presentation/login_screen.dart';
import 'package:reservamobile/features/notifications/presentation/notifications_screen.dart';
import 'package:reservamobile/features/reviews/presentation/reviews_screen.dart';
import 'package:reservamobile/features/shell/presentation/main_shell.dart';
import 'package:reservamobile/features/support/presentation/support_screen.dart';

class AppRoute {
  static const String shell = '/app';
  static const String login = '/login';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static String detail(String id) => '/detail/$id';
  static String booking(String id) => '/booking/$id';
  static String reviews(String id) => '/reviews/$id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.shell,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoute.shell,
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: AppRoute.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoute.support,
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) =>
          DetailScreen(establishmentId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/booking/:id',
      builder: (context, state) => BookingScreen(
        establishmentId: state.pathParameters['id'] ?? '',
        initialServiceId: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: '/reviews/:id',
      builder: (context, state) =>
          ReviewsScreen(establishmentId: state.pathParameters['id'] ?? ''),
    ),
  ],
);
