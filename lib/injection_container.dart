import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:emp_recog_plat/core/network/network_connection_updates.dart';
import 'package:emp_recog_plat/features/admin_dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/credentials/data/repositories/credentials_repository_impl.dart';
import 'features/credentials/domain/repositories/credentials_repository.dart';
import 'features/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'features/emp_dashboard/data/repositories/emp_home_repository_impl.dart';
import 'features/emp_dashboard/data/repositories/emp_profile_repository_impl.dart';
import 'features/emp_dashboard/data/repositories/emp_search_repository_impl.dart';
import 'features/emp_dashboard/domain/repositories/emp_home_repository.dart';
import 'features/emp_dashboard/domain/repositories/emp_profile_repository.dart';
import 'features/emp_dashboard/domain/repositories/emp_search_repository.dart';
import 'features/notifications/data/repository/notifications_repository_impl.dart';
import 'features/notifications/domain/repository/notifications_repository.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
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
      () => SplashRepositoryImpl(sharedPreferences: sl(), networkInfo: sl()));

  //! Features - Credentials
  // Bloc
  sl.registerFactory(() => CredentialsBloc());

  // Repository
  sl.registerLazySingleton<CredentialsRepository>(
      () => CredentialsRepositoryImpl(networkInfo: sl()));

  //! Features - Notifications
  // Bloc
  sl.registerFactory(() => NotificationBloc());

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(networkInfo: sl()));

  //! Features - Admin Dashboard
  // Bloc
  sl.registerFactory(() => AdminDashboardBloc());

  //! Features - Employee Dashboard
  // Bloc
  sl.registerFactory(() => EmpDashboardBloc());

  // Repository
  sl.registerLazySingleton<EmployeeHomeRepository>(() =>
      EmployeeHomeRepositoryImpl(sharedPreferences: sl(), networkInfo: sl()));
  sl.registerLazySingleton<EmployeeSearchRepository>(() =>
      EmployeeSearchRepositoryImpl(sharedPreferences: sl(), networkInfo: sl()));
  sl.registerLazySingleton<EmployeeProfileRepository>(() =>
      EmployeeProfileRepositoryImpl(
          sharedPreferences: sl(), networkInfo: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! Core
  sl.registerLazySingleton<NetworkConnectionUpdates>(
      () => NetworkConnectionUpdatesImpl(sl(), sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Connectivity());
}
