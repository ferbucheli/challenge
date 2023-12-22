import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';

import '../../../../core/constants/constants.dart';

class UserInput extends StatelessWidget {
  const UserInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          icon: UiUtils.getSvg(
            AppIcons.user,
            color: Colors.black38,
            width: 20.rf(context),
          ),
          label: 'Usuario',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginFormCubit>().onUsernameChange(value);
          },
          errorMessage: state.isFormPosted ? state.usuario.errorMessage : null,
        );
      },
    );
  }
}
