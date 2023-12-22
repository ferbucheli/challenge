/// The code you provided is configuring a router using the `go_router` package in Dart.
import 'package:frontend/core/router/app_router_notifier.dart';
import 'package:frontend/features/auth/presentation/screens/screens.dart';
import 'package:frontend/features/home/presentation/screens/screens.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/bloc.dart';

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
        path: '/books/:bookCode',
        builder: (context, state) {
          final bookCode = state.pathParameters['bookCode'];
          return BookDetailScreen(bookCode: bookCode!);
        }),

    GoRoute(
        path: '/loans/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return LoansByUserScreen(userId: userId!);
        }),

    ///* Admin Routes
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminScreen(),
    ),
  ],
  redirect: (context, state) {
    final isGoingTo = state.fullPath;

    if (isGoingTo == '/splash' && authBloc.state is Checking) {
      return null;
    }
    if (authBloc.state is UserAuthenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/splash') return '/home';
    }
    if (authBloc.state is AdminAuthenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/splash') return '/admin';
    }
    if (authBloc.state is Unauthenticated) {
      if (isGoingTo == '/login') return null;
      return '/login';
    }
    return null;
  },
);
