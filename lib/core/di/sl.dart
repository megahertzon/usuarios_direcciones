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
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> serviceLocatorInit() async {
  sl.registerSingleton<Logger>(Logger());

  final db = await $FloorAppDatabase.databaseBuilder('app.db').build();
  sl.registerSingleton<AppDatabase>(db);

  sl.registerSingleton<UserDao>(db.userDao);
  sl.registerSingleton<AddressDao>(db.addressDao);

  final count = await sl<UserDao>().countUsers() ?? 0;
  if (count == 0) {
    sl<Logger>().i('No users found, seeding database...');
    final johnId = await sl<UserDao>().insertUser(
      UserModel(
        firstName: 'Nelson',
        lastName: 'Rodríguez',
        birthDate: DateTime(1990, 6, 15).millisecondsSinceEpoch,
      ),
    );
    await sl<AddressDao>().insertAddress(
      AddressModel(
        userId: johnId,
        street: 'Cra 78 # 102-12',
        city: 'Bogotá',
        country: 'Colombia',
      ),
    );
    await sl<AddressDao>().insertAddress(
      AddressModel(
        userId: johnId,
        street: 'Av. 1 # 2-3',
        city: 'Medellín',
        country: 'Colombia',
      ),
    );

    final aliceId = await sl<UserDao>().insertUser(
      UserModel(
        firstName: 'Sandra',
        lastName: 'Cortes',
        birthDate: DateTime(1993, 3, 30).millisecondsSinceEpoch,
      ),
    );
    await sl<AddressDao>().insertAddress(
      AddressModel(
        userId: aliceId,
        street: 'Calle 80 # 20-15',
        city: 'Bogotá',
        country: 'Colombia',
      ),
    );
  }

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
