import 'package:freezed_annotation/freezed_annotation.dart';
import 'address.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    int? id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    @Default([]) List<Address> addresses,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}