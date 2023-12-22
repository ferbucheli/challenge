import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/custom_button.dart';
import 'package:frontend/features/shared/widgets/utils/ui_utils.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';

class AdminBooksScreen extends StatelessWidget {
  const AdminBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
        title: const Text('Administrar libros'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BooksBloc>(),
      child: BlocConsumer<BooksBloc, BooksState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: 20.rh(context)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Administrador de biblioteca',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              SizedBox(height: 20.rh(context)),
              CustomButton(
                  onPressed: () {
                    context.go('/admin/books/add');
                  },
                  buttonTitle: 'Agregar libro'),
              if (state is LoadedBooks)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${state.books[index].code} ${state.books[index].title}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(state.books[index].author,
                            style: Theme.of(context).textTheme.bodyMedium),
                      );
                    },
                  ),
                ),
              if (state is LoadingBooks)
                Expanded(
                  child: Center(
                    child: UiUtils.progress(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
