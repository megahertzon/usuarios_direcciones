import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/features/core/error/failures.dart';
import 'package:usuarios_direcciones/features/main_screen/application/usecases/list_user_summaries.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final ListUserSummaries _listSummaries;

  UsersCubit({required ListUserSummaries listSummaries})
    : _listSummaries = listSummaries,
      super(const UsersState());

  Future<void> loadSummaries() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _listSummaries();
    res.fold(
      (f) => emit(state.copyWith(isLoading: false, error: _msg(f))),
      (list) => emit(state.copyWith(isLoading: false, summaries: list)),
    );
  }

  String _msg(Failure f) => f.when(
    database: (m) => m ?? 'Error de base de datos',
    server: (m) => m ?? 'Error del servidor',
    cache: (m) => m ?? 'Error de caché',
    unexpected: (m) => m ?? 'Error inesperado',
  );
}
