class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);
  @override
  String toString() => 'DatabaseException: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
  @override
  String toString() => 'CacheException: $message';
}
