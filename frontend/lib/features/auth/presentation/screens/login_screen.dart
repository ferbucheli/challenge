import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/presentation/bloc/bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/widgets.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../injection_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildBody(),
    );
  }

  MultiBlocProvider buildBody() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginFormCubit>(create: (context) => sl<LoginFormCubit>()),
      ],
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Error) {
          showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        final checkingRequest = state is Checking || state is UserAuthenticated;
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              ...figures,
              LoginText(textStyles: textStyles),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.rh(context)),
                      Text(
                        'Por favor, ingresa tu usuario y contraseña',
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.black54),
                      ),
                      SizedBox(height: 20.rh(context)),
                      UserInput(), // Custom Widget
                      SizedBox(height: 20.rh(context)),
                      PasswordInput(), // Custom Widget
                      SizedBox(height: 30.rh(context)),
                      SizedBox(
                        width: 200.rw(context),
                        height: 50.rh(context),
                        child: checkingRequest
                            ? UiUtils.progress(width: 10, height: 10)
                            : CustomButton(
                                color: Color.fromARGB(255, 51, 69, 150),
                                textColor: Colors.white,
                                height: 10,
                                width: 20,
                                buttonTitle: 'Ingresar',
                                onPressed: () {
                                  final cubit = context.read<LoginFormCubit>();
                                  cubit.touchEveryField();
                                  final state = cubit.state;
                                  if (state.isValid) {
                                    final username = state.usuario.value;
                                    final password = state.password.value;
                                    context.read<AuthBloc>().add(
                                          LoginEvent(
                                              username: username,
                                              password: password),
                                        );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
    required this.textStyles,
  });

  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 80.rw(context),
      top: (30 + (257 / 2) - 20).rh(context),
      child: Image.asset(
        'assets/img/logo_espol.png',
        height: 200.rh(context),
        width: 200.rw(context),
      ),
    );
  }
}
