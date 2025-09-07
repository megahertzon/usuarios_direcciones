import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repo;
  DeleteUser(this.repo);

  Future<Either<Failure, Unit>> call(int id) {
    return repo.delete(id);
  }
}
