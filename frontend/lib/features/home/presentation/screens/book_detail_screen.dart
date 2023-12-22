import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/home/presentation/bloc/reservation/reservation_bloc.dart';
import 'package:frontend/features/shared/widgets/utils/ui_utils.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    Key? key,
    required this.bookCode,
  }) : super(key: key);

  final String bookCode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                sl<BookDetailBloc>()..add(GetBookEvent(bookCode))),
        BlocProvider(
            create: (context) =>
                sl<ReservationBloc>()..add(ReserveBookEvent(bookCode))),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Book Detail'),
            leading: IconButton(
              onPressed: () {
                sl<ReservationBloc>().add(CancelReservationEvent(bookCode));
                context.go('/home');
              },
              icon: const Icon(Icons.arrow_back),
            )),
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading) {
              return Center(
                child: UiUtils.booksLoading(
                  width: 200.rw(context),
                  height: 200.rh(context),
                ),
              );
            } else if (state is BookDetailError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is BookDetailLoaded) {
              return BlocConsumer<ReservationBloc, ReservationState>(
                listener: (context, state) {
                  if (state is ReservationConfirmed) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.info(
                        message: 'Libro reservado temporalmente',
                      ),
                    );
                  } else if (state is ReservationAlreadyConfirmed) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        message: 'Libro prestado exitosamente',
                      ),
                    );
                    context.go('/home');
                  } else if (state is ReservationError) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(
                        message: state.message,
                      ),
                    );
                  } else if (state is ReservationCancelled) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.info(
                        message: 'Reserva cancelada',
                      ),
                    );
                    context.go('/home');
                  } else if (state is ReservationDuplicate) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.error(
                        message:
                            'No se puede reservar el mismo libro dos veces',
                      ),
                    );
                    context.go('/home');
                  }
                },
                builder: (context, reservationState) {
                  return buildOnLoaded(state, context);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buildOnLoaded(BookDetailLoaded state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Text(
            state.book.title,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            state.book.author,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            state.book.description,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Available: ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                state.book.quantity.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context
                  .read<ReservationBloc>()
                  .add(ConfirmReservationEvent(bookCode));
            },
            child: const Text('Prestar'),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
