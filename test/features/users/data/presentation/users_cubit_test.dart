import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/create_users.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/delete_user.dart';
import 'package:usuarios_direcciones/features/edit_user/application/get_user_by_id.dart';
import 'package:usuarios_direcciones/features/edit_user/application/update_user.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/users_screen/application/usecases/list_user_summaries.dart';
import 'package:usuarios_direcciones/features/users_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/users_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/users_screen/presentation/cubit/users_state.dart';

class _ListSumm extends Mock implements ListUserSummaries {}

class _Create extends Mock implements CreateUser {}

class _Update extends Mock implements UpdateUser {}

class _Delete extends Mock implements DeleteUser {}

class _GetById extends Mock implements GetUserById {}

void main() {
  late _ListSumm listSumm;
  late _Create createUser;
  late _Update updateUser;
  late _Delete deleteUser;
  late _GetById getById;

  setUp(() {
    listSumm = _ListSumm();
    createUser = _Create();
    updateUser = _Update();
    deleteUser = _Delete();
    getById = _GetById();
  });

  UsersCubit buildCubit() => UsersCubit(
    listSummaries: listSumm,
    createUser: createUser,
    updateUser: updateUser,
    deleteUser: deleteUser,
    getUserById: getById,
  );

  blocTest<UsersCubit, UsersState>(
    'loadSummaries emite loading → data',
    build: () {
      when(() => listSumm()).thenAnswer(
        (_) async => Right([const UserSummary(1, 'Ana', 'García', 2)]),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.loadSummaries(),
    expect: () => [
      const UsersState(isLoading: true),
      const UsersState(
        isLoading: false,
        summaries: [UserSummary(1, 'Ana', 'García', 2)],
      ),
    ],
    verify: (_) => verify(() => listSumm()).called(1),
  );

  blocTest<UsersCubit, UsersState>(
    'loadById llena selected o error',
    build: () {
      when(() => getById(1)).thenAnswer(
        (_) async => Right(
          User(
            id: 1,
            firstName: 'Ana',
            lastName: 'García',
            birthDate: DateTime(1995, 4, 10),
            addresses: const [],
          ),
        ),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.loadById(1),
    expect: () => [
      const UsersState(isLoading: true),
      isA<UsersState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.userSelected?.id, 'selected.id', 1),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'delete emite loading → loadSummaries emite valor por defecto',
    build: () {
      when(() => deleteUser(1)).thenAnswer((_) async => const Right(unit));
      when(
        () => listSumm(),
      ).thenAnswer((_) async => const Right(<UserSummary>[]));
      return buildCubit();
    },
    act: (cubit) => cubit.delete(1),
    expect: () => [
      const UsersState(isLoading: true),
      const UsersState(isLoading: false, summaries: <UserSummary>[]),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'propaga failure en loadSummaries emite valor por defecto db failure',
    build: () {
      when(
        () => listSumm(),
      ).thenAnswer((_) async => const Left(Failure.database(null)));
      return buildCubit();
    },
    act: (cubit) => cubit.loadSummaries(),
    expect: () => [
      const UsersState(isLoading: true),
      const UsersState(isLoading: false, error: 'Error de base de datos'),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'propaga failure en loadSummaries emite db error',
    build: () {
      when(
        () => listSumm(),
      ).thenAnswer((_) async => const Left(Failure.database('db error')));
      return buildCubit();
    },
    act: (cubit) => cubit.loadSummaries(),
    expect: () => [
      const UsersState(isLoading: true),
      const UsersState(isLoading: false, error: 'db error'),
    ],
  );
}
