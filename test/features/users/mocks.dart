import 'package:mocktail/mocktail.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/features/shared/domain/repositories/user_repository.dart';
import 'package:usuarios_direcciones/features/users_screen/domain/entities/user_summary.dart';

class MockUserRepository extends Mock implements UserRepository {}

void registerFallbacks() {
  // Si llegas a stubear métodos con tipos complejos, registra aquí fallbacks
  registerFallbackValue(const UserSummary(0, '', '', 0));

  registerFallbackValue(
    User(
      id: 0,
      firstName: '',
      lastName: '',
      birthDate: DateTime.now(),
      addresses: [],
    ),
  );
}
