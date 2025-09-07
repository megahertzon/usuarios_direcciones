// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  AddressDao? _addressDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `birthDate` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `addresses` (`id` INTEGER, `userId` INTEGER NOT NULL, `street` TEXT NOT NULL, `city` TEXT NOT NULL, `country` TEXT NOT NULL, FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `user_with_count` AS   SELECT u.id, u.firstName, u.lastName,\n         COUNT(a.id) AS addressCount\n  FROM users u\n  LEFT JOIN addresses a ON a.userId = u.id\n  GROUP BY u.id\n');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  AddressDao get addressDao {
    return _addressDaoInstance ??= _$AddressDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'birthDate': item.birthDate
                }),
        _userModelUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'birthDate': item.birthDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  final UpdateAdapter<UserModel> _userModelUpdateAdapter;

  @override
  Future<List<UserModel>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            birthDate: row['birthDate'] as int));
  }

  @override
  Future<UserModel?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            birthDate: row['birthDate'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM users WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> countUsers() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<UserWithCount>> getUsersWithAddressCount() async {
    return _queryAdapter.queryList('SELECT * FROM user_with_count',
        mapper: (Map<String, Object?> row) => UserWithCount(
            row['id'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['addressCount'] as int));
  }

  @override
  Future<List<AddressModel>> getAddressesForUser(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM addresses WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => AddressModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            street: row['street'] as String,
            city: row['city'] as String,
            country: row['country'] as String),
        arguments: [userId]);
  }

  @override
  Future<List<UserWithCount>> getUsersWithCountView() async {
    return _queryAdapter.queryList('SELECT * FROM user_with_count',
        mapper: (Map<String, Object?> row) => UserWithCount(
            row['id'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['addressCount'] as int));
  }

  @override
  Future<int> insertUser(UserModel user) {
    return _userModelInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _userModelUpdateAdapter.update(user, OnConflictStrategy.abort);
  }
}

class _$AddressDao extends AddressDao {
  _$AddressDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _addressModelInsertionAdapter = InsertionAdapter(
            database,
            'addresses',
            (AddressModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'street': item.street,
                  'city': item.city,
                  'country': item.country
                }),
        _addressModelDeletionAdapter = DeletionAdapter(
            database,
            'addresses',
            ['id'],
            (AddressModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'street': item.street,
                  'city': item.city,
                  'country': item.country
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AddressModel> _addressModelInsertionAdapter;

  final DeletionAdapter<AddressModel> _addressModelDeletionAdapter;

  @override
  Future<List<AddressModel>> findByUser(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM addresses WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => AddressModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            street: row['street'] as String,
            city: row['city'] as String,
            country: row['country'] as String),
        arguments: [userId]);
  }

  @override
  Future<int> insertAddress(AddressModel address) {
    return _addressModelInsertionAdapter.insertAndReturnId(
        address, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAddress(AddressModel address) async {
    await _addressModelDeletionAdapter.delete(address);
  }
}
