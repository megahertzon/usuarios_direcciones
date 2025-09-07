


import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/users_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/address.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getAll();
  Future<Either<Failure, User>> getById(int id);
  Future<Either<Failure, int>> create(User user);
  Future<Either<Failure, Unit>> update(User user);
  Future<Either<Failure, Unit>> delete(int id);
  Future<Either<Failure, int>> addAddress(int userId, Address address);
  Future<Either<Failure, Unit>> removeAddress(int addressId);
  Future<Either<Failure, List<UserSummary>>> listSummaries();
}