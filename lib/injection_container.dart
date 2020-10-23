import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';
import 'features/credentials/data/repositories/credentials_repository_impl.dart';
import 'features/credentials/domain/repositories/credentials_repository.dart';
import 'features/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/splash/domain/repositories/splash_repository.dart';
import 'features/splash/presentation/bloc/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Splash
  // Bloc
  sl.registerFactory(() => SplashBloc()); // SplashBloc(currentUser: sl()));

  // Repository
  sl.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(networkInfo: sl()));

  //! Features - Credentials
  // Bloc
  sl.registerFactory(() => CredentialsBloc());

  // Repository
  sl.registerLazySingleton<CredentialsRepository>(
      () => CredentialsRepositoryImpl(networkInfo: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => DataConnectionChecker());
}
