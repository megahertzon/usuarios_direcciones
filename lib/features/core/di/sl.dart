

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:usuarios_direcciones/features/core/database/app_database.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';

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
    final johnId = await sl<UserDao>().insertUser(UserModel(
      firstName: 'Nelson',
      lastName: 'Rodríguez',
      birthDate: DateTime(1990, 6, 15).millisecondsSinceEpoch,
    ));
    await sl<AddressDao>().insertAddress(AddressModel(
      userId: johnId, street: 'Cra 78 # 102-12', city: 'Bogotá', country: 'Colombia',
    ));
    await sl<AddressDao>().insertAddress(AddressModel(
      userId: johnId, street: 'Av. 1 # 2-3', city: 'Medellín', country: 'Colombia',
    ));

    final aliceId = await sl<UserDao>().insertUser(UserModel(
      firstName: 'Sandra',
      lastName: 'Cortes',
      birthDate: DateTime(1993, 3, 30).millisecondsSinceEpoch,
    ));
    await sl<AddressDao>().insertAddress(AddressModel(
      userId: aliceId, street: 'Calle 80 # 20-15', city: 'Bogotá', country: 'Colombia',
    ));
  }
}