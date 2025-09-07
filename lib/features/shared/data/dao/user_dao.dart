// ...existing code...
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:floor/floor.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_with_count.dart';

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

  @Query('SELECT COUNT(*) FROM users')
  Future<int?> countUsers();

  @Query('SELECT * FROM user_with_count')
  Future<List<UserWithCount>> getUsersWithAddressCount();

  @Query('SELECT * FROM addresses WHERE userId = :userId')
  Future<List<AddressModel>> getAddressesForUser(int userId);

  @Query('SELECT * FROM user_with_count')
  Future<List<UserWithCount>> getUsersWithCountView();
}
