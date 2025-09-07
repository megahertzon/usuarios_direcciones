import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class GetUserById {
  final UserRepository repo;
  GetUserById(this.repo);

  Future<Either<Failure, User>> call(int id) => repo.getById(id);
}
