import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/features/core/error/exceptions.dart';
import 'package:usuarios_direcciones/features/core/error/failures.dart';
import 'package:usuarios_direcciones/features/main_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/address.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDao _userDao;
  final AddressDao _addressDao;

  UserRepositoryImpl(this._userDao, this._addressDao);

  User _toEntity(UserModel u, List<AddressModel> rows) => User(
    id: u.id,
    firstName: u.firstName,
    lastName: u.lastName,
    birthDate: DateTime.fromMillisecondsSinceEpoch(u.birthDate),
    addresses: rows
        .map(
          (a) => Address(
            id: a.id,
            userId: a.userId,
            street: a.street,
            city: a.city,
            country: a.country,
          ),
        )
        .toList(),
  );

  @override
  Future<Either<Failure, List<User>>> getAll() async {
    try {
      final users = await _userDao.getAll();
      final result = <User>[];
      for (final u in users) {
        final addrs = await _userDao.getAddressesForUser(u.id!);
        result.add(_toEntity(u, addrs));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addAddress(int userId, Address address) {
    // TODO: implement addAddress
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> create(User user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> removeAddress(int addressId) {
    // TODO: implement removeAddress
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> update(User user) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserSummary>>> listSummaries() async {
    try {
      final rows = await _userDao
          .getUsersWithCountView(); // usando @DatabaseView
      final list = rows
          .map(
            (r) => UserSummary(r.id, r.firstName, r.lastName, r.addressCount),
          )
          .toList();
      return Right(list);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }
}
