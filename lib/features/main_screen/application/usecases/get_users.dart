import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/features/core/error/failures.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repo;
  GetUsers(this.repo);

  Future<Either<Failure, List<User>>> call() => repo.getAll();
}
