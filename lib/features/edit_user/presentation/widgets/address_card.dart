import 'package:flutter/material.dart';
import 'package:usuarios_direcciones/features/edit_user/presentation/widgets/address_row.dart';

class AddressCard extends StatelessWidget {
  final int index;
  final AddressRow row;
  final VoidCallback onRemove;

  const AddressCard({
    super.key,
    required this.index,
    required this.row,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Dirección ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: row.street,
              decoration: const InputDecoration(
                labelText: 'Calle/Carrera',
                hintText: 'Ej: Cra 7 # 10-12',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: row.city,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad',
                      hintText: 'Ej: Bogotá',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: row.country,
                    decoration: const InputDecoration(
                      labelText: 'País',
                      hintText: 'Ej: Colombia',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
