import 'package:flutter_test/flutter_test.dart';
import 'package:usuarios_direcciones/core/database/app_database.dart';
import 'package:usuarios_direcciones/features/shared/data/models/address_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_model.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_with_count.dart';

void main() {
  test('Floor in-memory: inserta y consulta view', () async {
    final db = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

    final uId = await db.userDao.insertUser(
      UserModel(
        firstName: 'Ana',
        lastName: 'García',
        birthDate: DateTime(1995, 4, 10).millisecondsSinceEpoch,
      ),
    );
    await db.addressDao.insertAddress(
      AddressModel(
        userId: uId,
        street: 'Cra 7',
        city: 'Bogotá',
        country: 'Colombia',
      ),
    );
    await db.addressDao.insertAddress(
      AddressModel(
        userId: uId,
        street: 'Av 1',
        city: 'Medellín',
        country: 'Colombia',
      ),
    );

    final viewRows = await db.userDao.getUsersWithCountView();
    expect(viewRows, isA<List<UserWithCount>>());
    expect(viewRows.single.addressCount, 2);

    await db.close();
  });
}
