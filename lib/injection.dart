import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/meal_local_data_source.dart';
import 'data/datasources/meal_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/meal_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/meal_repository.dart';
import 'domain/usecases/auth_usecases.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/meal/meal_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  //! Core
  // App-wide Cubits
  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => LocaleCubit());
  sl.registerLazySingleton(() => CartCubit());

  //! Features - Auth
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      googleSignInUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  //! Features - Meals
  sl.registerFactory(() => MealCubit(repository: sl()));

  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<MealLocalDataSource>(
    () => MealLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
}
