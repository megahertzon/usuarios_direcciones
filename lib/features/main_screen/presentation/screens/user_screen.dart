import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:usuarios_direcciones/features/shared/data/dao/user_dao.dart';
import 'package:usuarios_direcciones/features/shared/data/models/user_with_count.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<UserWithCount>> _future;

  @override
  void initState() {
    super.initState();
    _future = GetIt.I<UserDao>().getUsersWithAddressCount();
  }

  Future<void> _refresh() async {
    final f = GetIt.I<UserDao>().getUsersWithAddressCount();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('Usuarios'), elevation: 0),
      body: FutureBuilder<List<UserWithCount>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Sin usuarios'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        _UserTile(row: items[i]),
                        if (i != items.length - 1)
                          const Divider(height: 1, indent: 72, endIndent: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserWithCount row;
  const _UserTile({required this.row});

  String get initials {
    final f = row.firstName.isNotEmpty ? row.firstName[0] : '';
    final l = row.lastName.isNotEmpty ? row.lastName[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 20, child: Text(initials)),
      title: Text(
        '${row.firstName} ${row.lastName}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('Direcciones: ${row.addressCount}'),
      trailing: Wrap(
        spacing: 12,
        children: [
          TextButton(
            onPressed: () {
              /* TODO: editar */
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              /* TODO: eliminar */
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
