
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:usuarios_direcciones/features/shared/domain/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/dao/user_dao.dart';


import 'package:usuarios_direcciones/features/shared/domain/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/models/user_model.dart';

@Database(version: 1, entities: [UserModel, AddressModel])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  AddressDao get addressDao;
}