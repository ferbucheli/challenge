import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';

import '../../../../core/constants/constants.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          icon: UiUtils.getSvg(
            AppIcons.lock,
            color: Colors.black38,
            width: 20.rf(context),
          ),
          label: 'Contraseña',
          obscureText: true,
          onChanged: (value) {
            context.read<LoginFormCubit>().onPasswordChanged(value);
          },
          errorMessage: state.isFormPosted ? state.password.errorMessage : null,
        );
      },
    );
  }
}
