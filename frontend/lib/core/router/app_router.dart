/// The code you provided is configuring a router using the `go_router` package in Dart.
import 'package:go_router/go_router.dart';

final authBloc = sl<AuthBloc>();
final authListenable = AuthBlocListenable(authBloc);

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: authListenable,
  routes: [
    ///* CheckAuth Screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    ///* Home Routes
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: '/order-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: id);
      },
    ),
  ],
  redirect: (context, state) {
    final isGoingTo = state.fullPath;

    if (isGoingTo == '/splash' && authBloc.state is Checking) {
      return null;
    }
    if (authBloc.state is Authenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/splash') return '/home';
    }
    if (authBloc.state is Unauthenticated) {
      if (isGoingTo == '/login') return null;
      return '/login';
    }
    return null;
  },
);
