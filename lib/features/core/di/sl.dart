

import 'package:get_it/get_it.dart';
import 'package:usuarios_direcciones/features/core/database/app_database.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/dao/user_dao.dart';

final sl = GetIt.instance;

Future<void> initDI() async {

  final db = await $FloorAppDatabase.databaseBuilder('app.db').build();
  sl.registerSingleton<AppDatabase>(db);

  sl.registerSingleton<UserDao>(db.userDao);
  sl.registerSingleton<AddressDao>(db.addressDao);
}