import 'package:flutter/material.dart';
import 'package:hubilogist_transportistas/core/theme/theme.dart';
import 'package:hubilogist_transportistas/features/shared/widgets/utils/ui_utils.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            UiUtils.progress(width: 150.rw(context), height: 150.rh(context)),
      ),
    );
  }
}
