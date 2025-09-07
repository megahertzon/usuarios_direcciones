import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/users_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class ListUserSummaries {
  final UserRepository repo;
  ListUserSummaries(this.repo);

  Future<Either<Failure, List<UserSummary>>> call() => repo.listSummaries();
}