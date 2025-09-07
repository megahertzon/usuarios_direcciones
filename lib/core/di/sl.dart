import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:usuarios_direcciones/core/database/app_database.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/delete_user.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/create_users.dart';
import 'package:usuarios_direcciones/features/edit_user/application/get_user_by_id.dart';
import 'package:usuarios_direcciones/features/edit_user/application/update_user.dart';
import 'package:usuarios_direcciones/features/users_screen/application/usecases/get_users.dart';
import 'package:usuarios_direcciones/features/users_screen/application/usecases/list_user_summaries.dart';
import 'package:usuarios_direcciones/features/users_screen/data/repositories/user_repository_impl.dart';
import 'package:usuarios_direcciones/features/users_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> serviceLocatorInit() async {
  sl.registerSingleton<Logger>(Logger());

  final db = await $FloorAppDatabase.databaseBuilder('app.db').build();
  sl.registerSingleton<AppDatabase>(db);

  sl.registerSingleton<UserDao>(db.userDao);
  sl.registerSingleton<AddressDao>(db.addressDao);

  // ---------------- Repository ----------------
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserDao>(), sl<AddressDao>()),
  );

  // ---------------- Use Cases ----------------
  sl.registerFactory(() => GetUsers(sl()));
  sl.registerFactory(() => ListUserSummaries(sl()));
  sl.registerFactory(() => CreateUser(sl()));
  sl.registerFactory(() => DeleteUser(sl()));
  sl.registerFactory(() => UpdateUser(sl()));
  sl.registerFactory(() => GetUserById(sl()));

  // ---------------- Cubit ----------------
  sl.registerFactory(
    () => UsersCubit(
      listSummaries: sl(),
      createUser: sl(),
      deleteUser: sl(),
      updateUser: sl(),
      getUserById: sl(),
    ),
  );
}
