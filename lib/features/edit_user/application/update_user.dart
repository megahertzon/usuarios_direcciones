import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repo;
  UpdateUser(this.repo);

  /// Actualiza al usuario (y sus direcciones, según la política del repo).
  Future<Either<Failure, Unit>> call(User user) {
    return repo.update(user);
  }
}
