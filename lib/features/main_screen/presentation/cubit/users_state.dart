import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:usuarios_direcciones/features/main_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';

part 'users_state.freezed.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState({
    @Default(false) bool isLoading,
    String? error,
    @Default(<UserSummary>[]) List<UserSummary> summaries,
    User? userSelected,
  }) = _UsersState;
}
