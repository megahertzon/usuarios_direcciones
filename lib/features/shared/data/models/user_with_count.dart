import 'package:floor/floor.dart';

@DatabaseView('''
  SELECT u.id, u.firstName, u.lastName,
         COUNT(a.id) AS addressCount
  FROM users u
  LEFT JOIN addresses a ON a.userId = u.id
  GROUP BY u.id
''', viewName: 'user_with_count')
class UserWithCount {
  final int id;
  final String firstName;
  final String lastName;
  final int addressCount;

  UserWithCount(this.id, this.firstName, this.lastName, this.addressCount);
}