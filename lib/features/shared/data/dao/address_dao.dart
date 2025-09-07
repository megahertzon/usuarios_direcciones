


import 'package:floor/floor.dart';
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';

@dao
abstract class AddressDao {
  @Query('SELECT * FROM addresses WHERE userId = :userId')
  Future<List<AddressModel>> findByUser(int userId);

  @insert
  Future<int> insertAddress(AddressModel address);

  @delete
  Future<void> deleteAddress(AddressModel address);

  @Query('DELETE FROM addresses WHERE id = :id')
  Future<void> deleteAddressById(int id);
}