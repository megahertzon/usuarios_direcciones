import 'package:floor/floor.dart';
import 'package:usuarios_direcciones/features/shared/domain/data/models/user_model.dart';

@Entity(
  tableName: 'addresses',
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: UserModel,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class AddressModel {
  @primaryKey
  final int? id;
  final int userId;
  final String street;
  final String city;
  final String country;

  AddressModel({
    this.id,
    required this.userId,
    required this.street,
    required this.city,
    required this.country,
  });
}
