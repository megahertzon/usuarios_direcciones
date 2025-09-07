import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/features/edit_user/presentation/widgets/address_card.dart';
import 'package:usuarios_direcciones/features/edit_user/presentation/widgets/address_row.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_state.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/address.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';

class UserEditPage extends StatefulWidget {
  final User user;
  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late DateTime _birthDate;

  // Lista editable de direcciones, preservando ids
  late List<AddressRow> _rows;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user.firstName);
    _lastNameCtrl = TextEditingController(text: widget.user.lastName);
    _birthDate = widget.user.birthDate;

    _rows = widget.user.addresses
        .map((a) => AddressRow.fromAddress(a))
        .toList();
    if (_rows.isEmpty) _rows.add(AddressRow.empty()); // opcional
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      locale: const Locale('es', 'CO'),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _addRow() => setState(() => _rows.add(AddressRow.empty()));
  void _removeRow(int i) => setState(() {
    _rows[i].dispose();
    _rows.removeAt(i);
    if (_rows.isEmpty) _rows.add(AddressRow.empty());
  });

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cleaned = _rows
        .where((r) => r.hasAny)
        .map(
          (r) => Address(
            id: r.id, // preserva id (si existe)
            userId: widget.user.id ?? 0, // el repo/DB lo usará
            street: r.street.text.trim(),
            city: r.city.text.trim(),
            country: r.country.text.trim(),
          ),
        )
        .toList();

    final updated = widget.user.copyWith(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      birthDate: _birthDate,
      addresses: cleaned,
    );

    final cubit = context.read<UsersCubit>();
    await cubit.update(updated);

    if (mounted && cubit.state.error == null) {
      Navigator.of(context).pop(true); // indica que se actualizó
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersState>(
      listenWhen: (p, c) => p.error != c.error && c.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Editar usuario')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Nombre
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                // Apellido
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                // Fecha de nacimiento
                InkWell(
                  onTap: _pickBirthDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_birthDate.year}-${_birthDate.month.toString().padLeft(2, '0')}-${_birthDate.day.toString().padLeft(2, '0')}',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Direcciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Direcciones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._rows.indexed.map((e) {
                  final i = e.$1;
                  final r = e.$2;
                  return AddressCard(
                    key: ValueKey(r),
                    index: i,
                    row: r,
                    onRemove: () => _removeRow(i),
                  );
                }),

                const SizedBox(height: 24),

                BlocBuilder<UsersCubit, UsersState>(
                  builder: (_, state) {
                    final saving = state.isLoading;
                    return FilledButton.icon(
                      onPressed: saving ? null : _save,
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(saving ? 'Guardando...' : 'Guardar cambios'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
