// service locator
import 'package:dio/dio.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/network/network.dart';
import 'package:frontend/features/home/data/datasources/datasources.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';
import 'package:frontend/features/home/domain/usecases/create_book.dart';
import 'package:frontend/features/home/domain/usecases/usecases.dart';
import 'package:frontend/features/home/presentation/bloc/reservation/reservation_bloc.dart';
import 'package:frontend/features/shared/data/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'features/auth/data/datasources/datasources.dart';
import 'features/auth/data/repositories/repositories.dart';
import 'features/auth/domain/repositories/repositories.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/presentation/bloc/bloc.dart';
import 'features/home/data/repositories/repositories.dart';
import 'features/home/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External

  sl.registerLazySingleton(() => Dio(BaseOptions(baseUrl: Environment.apiUrl)));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => KeyValueStorageServiceImpl());

  //* Data sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl(), sl()));

  //* Repository

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  //* Use cases

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetBook(sl()));
  sl.registerLazySingleton(() => ReserveBook(sl()));
  sl.registerLazySingleton(() => CancelReservation(sl()));
  sl.registerLazySingleton(() => LoanUseCase(sl()));
  sl.registerLazySingleton(() => GetLoansByUser(repository: sl()));
  sl.registerLazySingleton(() => ReturnBook(sl()));
  sl.registerLazySingleton(() => GetLoans(sl()));
  sl.registerLazySingleton(() => CreateBook(sl()));

  //! Auth

  sl.registerSingleton<AuthBloc>(AuthBloc(
    loginUseCase: sl(),
    keyValueStorageService: sl(),
  ));

  sl.registerFactory(
    () => LoginFormCubit(),
  );

  //! Home

  sl.registerFactory(() => BooksBloc(
        getBooks: sl(),
        returnBook: sl(),
        createBook: sl(),
      ));

  sl.registerFactory(() => BookDetailBloc(
        getBook: sl(),
      ));

  sl.registerFactory(() => ReservationBloc(
        cancelReservation: sl(),
        reserveBook: sl(),
        loan: sl(),
      ));

  sl.registerFactory(() => LoansBloc(
        getLoansByUser: sl(),
        getLoans: sl(),
      ));
}
