


import 'package:floor/floor.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/models/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<UserModel>> getAll();

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserModel?> findById(int id);

  @insert
  Future<int> insertUser(UserModel user);

  @update
  Future<void> updateUser(UserModel user);

  @Query('DELETE FROM users WHERE id = :id')
  Future<void> deleteById(int id);
}