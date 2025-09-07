import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/address_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_with_count.dart';
import 'package:usuarios_direcciones/features/users_screen/data/repositories/user_repository_impl.dart';

class _UserDao extends Mock implements UserDao {}

class _AddrDao extends Mock implements AddressDao {}

void main() {
  late _UserDao userDao;
  late _AddrDao addrDao;
  late UserRepositoryImpl repo;

  setUp(() {
    userDao = _UserDao();
    addrDao = _AddrDao();
    repo = UserRepositoryImpl(userDao, addrDao);
  });

  test('getAll mapea a entidades', () async {
    when(() => userDao.getAll()).thenAnswer(
      (_) async => [
        UserModel(
          id: 1,
          firstName: 'Ana',
          lastName: 'García',
          birthDate: DateTime(1995, 4, 10).millisecondsSinceEpoch,
        ),
      ],
    );
    when(() => userDao.getAddressesForUser(1)).thenAnswer(
      (_) async => [
        AddressModel(
          id: 10,
          userId: 1,
          street: 'Cra 7',
          city: 'Bogotá',
          country: 'Colombia',
        ),
      ],
    );

    final res = await repo.getAll();

    expect(res.isRight(), true);
    final list = res.getOrElse(() => []);
    expect(list.first.addresses.length, 1);
  });

  test('delete retorna Right(unit) y llama DAO', () async {
    when(() => userDao.deleteById(1)).thenAnswer((_) async => Future.value());

    final res = await repo.delete(1);

    expect(res, const Right(unit));
    verify(() => userDao.deleteById(1)).called(1);
  });

  test('listSummaries usa view y mapea DTO', () async {
    when(
      () => userDao.getUsersWithCountView(),
    ).thenAnswer((_) async => [UserWithCount(1, 'Ana', 'García', 2)]);

    final res = await repo.listSummaries();
    final list = res.getOrElse(() => []);
    expect(list.single.addressCount, 2);
  });
}
