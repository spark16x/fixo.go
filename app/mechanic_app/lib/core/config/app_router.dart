import 'package:go_router/go_router.dart';

import '../../features/auth/login_page.dart';
import '../../features/home/home_page.dart';
import '../../features/requests/incoming_requests_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/incoming',
      builder: (_, __) => const IncomingRequestsPage(),
    ),
  ],
);
