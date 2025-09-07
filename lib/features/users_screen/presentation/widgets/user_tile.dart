import 'package:flutter/material.dart';
import 'package:usuarios_direcciones/features/users_screen/domain/entities/user_summary.dart';

class UserTile extends StatelessWidget {
  final UserSummary summary;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserTile({
    required this.summary,
    required this.onEdit,
    required this.onDelete,
  });

  String get _initials {
    final f = summary.firstName.isNotEmpty ? summary.firstName[0] : '';
    final l = summary.lastName.isNotEmpty ? summary.lastName[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 20, child: Text(_initials)),
      title: Text(
        '${summary.firstName} ${summary.lastName}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('Direcciones: ${summary.addressCount}'),
      trailing: Wrap(
        spacing: 12,
        children: [
          TextButton(onPressed: onEdit, child: const Text('Editar')),
          TextButton(onPressed: onDelete, child: const Text('Eliminar')),
        ],
      ),
      onTap: onEdit,
    );
  }
}