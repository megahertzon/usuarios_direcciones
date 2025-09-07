import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/core/error/failures.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/delete_user.dart';
import 'package:usuarios_direcciones/features/add_user/application/use_cases/create_users.dart';
import 'package:usuarios_direcciones/features/edit_user/application/get_user_by_id.dart';
import 'package:usuarios_direcciones/features/edit_user/application/update_user.dart';
import 'package:usuarios_direcciones/features/main_screen/application/usecases/list_user_summaries.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_state.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';

class UsersCubit extends Cubit<UsersState> {
  final ListUserSummaries _listSummaries;
  final CreateUser _createUser;
  final DeleteUser _deleteUser;
  final UpdateUser _updateUser;
  final GetUserById _getUserById;

  UsersCubit({
    required ListUserSummaries listSummaries,
    required CreateUser createUser,
    required DeleteUser deleteUser,
    required UpdateUser updateUser,
    required GetUserById getUserById,
  }) : _listSummaries = listSummaries,
       _createUser = createUser,
       _deleteUser = deleteUser,
       _updateUser = updateUser,
       _getUserById = getUserById,
       super(const UsersState());

  Future<void> loadSummaries() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _listSummaries();
    res.fold(
      (f) => emit(state.copyWith(isLoading: false, error: _msg(f))),
      (list) => emit(state.copyWith(isLoading: false, summaries: list)),
    );
  }

  Future<void> create(User user) async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _createUser(user);
    res.fold((f) => emit(state.copyWith(isLoading: false, error: _msg(f))), (
      _,
    ) async {
      await loadSummaries();
    });
  }

  Future<void> delete(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _deleteUser(id);
    res.fold(
      (f) => emit(state.copyWith(isLoading: false, error: _msg(f))),
      (_) async => await loadSummaries(),
    );
  }

  Future<void> update(User user) async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _updateUser(user);
    res.fold(
      (f) => emit(state.copyWith(isLoading: false, error: _msg(f))),
      (_) async => await loadSummaries(),
    );
  }

  Future<void> loadById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _getUserById(id);
    res.fold(
      (f) => emit(
        state.copyWith(isLoading: false, error: _msg(f), userSelected: null),
      ),
      (user) => emit(state.copyWith(isLoading: false, userSelected: user)),
    );
  }

  String _msg(Failure f) => f.when(
    database: (m) => m ?? 'Error de base de datos',
    server: (m) => m ?? 'Error del servidor',
    cache: (m) => m ?? 'Error de caché',
    unexpected: (m) => m ?? 'Error inesperado',
  );
}
