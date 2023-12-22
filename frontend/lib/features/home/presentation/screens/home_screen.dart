import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/extensions/responsive_size.dart';
import 'package:frontend/features/auth/presentation/bloc/bloc.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/side_menu.dart';
import 'package:frontend/features/shared/widgets/utils/ui_utils.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logo_espol.png',
          height: 40,
        ),
      ),
      body: BlocProvider<BooksBloc>(
        create: (context) => sl<BooksBloc>(),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state is LoadedBooks) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BooksBloc>().add(GetBooksEvent());
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return ListTile(
                          onTap: () {
                            context.go('/books/${book.code}');
                          },
                          title: Text(
                            book.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(book.author,
                              style: Theme.of(context).textTheme.bodyMedium),
                          trailing: Icon(Icons.arrow_forward_ios_rounded));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 49.rh(context)),
                  child: CustomButton(
                    buttonTitle: 'Ver prestamos',
                    onPressed: () {
                      final authState = sl<AuthBloc>().state;
                      if (authState is UserAuthenticated) {
                        context.push('/loans/${authState.user.id}');
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ErrorBooks) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(
            child: UiUtils.booksLoading(),
          );
        }
      },
    );
  }
}
