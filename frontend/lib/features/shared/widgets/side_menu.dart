import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubilogist_transportistas/core/theme/extensions/responsive_size.dart';
import 'package:hubilogist_transportistas/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:hubilogist_transportistas/features/shared/widgets/widgets.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        return NavigationDrawer(
          elevation: 1,
          selectedIndex: navDrawerIndex,
          onDestinationSelected: (value) {
            setState(() {
              navDrawerIndex = value;
            });
            Scaffold.of(context).openDrawer();
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: CustomButton(
                  onPressed: () {
                    bloc.add(LogoutEvent());
                  },
                  buttonTitle: 'Cerrar sesión'),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 0),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, hasNotch ? 0 : 20, 16, 0),
              child: Row(
                children: [
                  Text('Powered by ', style: textStyles.labelLarge),
                  Image.asset(
                    'assets/img/logo-hubilogist.png',
                    height: 100.rh(context),
                    width: 100.rw(context),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
