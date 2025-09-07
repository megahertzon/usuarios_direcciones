import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserModel {
  @primaryKey
  final int? id;
  final String firstName;
  final String lastName;
  final int birthDate; // millisSinceEpoch

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });
}