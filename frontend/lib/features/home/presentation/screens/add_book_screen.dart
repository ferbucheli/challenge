import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar libro'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BooksBloc>(),
      child: BlocConsumer<BooksBloc, BooksState>(
        listener: (context, state) {
          if (state is BookCreated) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: 'Libro agregado exitosamente',
              ),
            );
            context.go('/admin/books');
          }
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
              Expanded(
                child: ListView(
                  children: [
                    _buildTextField(context, 'Código',
                        'Ingrese el código del libro', _codeController),
                    _buildTextField(context, 'Título',
                        'Ingrese el título del libro', _titleController),
                    _buildTextField(context, 'Autor',
                        'Ingrese el autor del libro', _authorController),
                    _buildTextField(
                        context,
                        'Descripción',
                        'Ingrese una descripción del libro',
                        _descriptionController),
                    _buildTextField(
                        context,
                        'Cantidad',
                        'Ingrese la cantidad de libros disponibles',
                        _quantityController),
                    SizedBox(height: 20.rh(context)),
                    CustomButton(
                      onPressed: () {
                        if (_authorController.text.isEmpty ||
                            _codeController.text.isEmpty ||
                            _descriptionController.text.isEmpty ||
                            _quantityController.text.isEmpty ||
                            _titleController.text.isEmpty) {
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.info(
                              message: 'Debe llenar todos los campos',
                            ),
                          );
                          return;
                        }
                        final book = Book(
                          code: _codeController.text,
                          title: _titleController.text,
                          author: _authorController.text,
                          description: _descriptionController.text,
                          quantity: int.parse(_quantityController.text),
                          reservedQuantity: 0,
                        );
                        context
                            .read<BooksBloc>()
                            .add(CreateBookEvent(book: book));
                      },
                      buttonTitle: 'Agregar libro',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String placeholder,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
