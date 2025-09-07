import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:usuarios_direcciones/features/shared/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';

import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_with_count.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [UserModel, AddressModel],
  views: [UserWithCount],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  AddressDao get addressDao;
}
