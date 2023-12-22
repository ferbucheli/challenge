import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/router/router.dart';
import 'package:frontend/features/auth/presentation/bloc/bloc.dart';
import 'package:frontend/injection_container.dart' as di;

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initializeEnv();
  await di.init();
  authBloc.add(CheckAuthStatusEvent());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        title: 'Hubilogist Transportistas',
        theme: AppTheme().getTheme(context),
      ),
    );
  }
}
