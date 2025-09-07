import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class CreateUser {
  final UserRepository repo;
  CreateUser(this.repo);

  Future<Either<Failure, int>> call(User u) => repo.create(u);
}
