import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_state.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/address.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  DateTime? _birthDate;

  final List<_AddressControllers> _addresses = [_AddressControllers()];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    for (final a in _addresses) {
      a.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 25, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      locale: const Locale('es', 'CO'),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _addAddressRow() {
    setState(() => _addresses.add(_AddressControllers()));
  }

  void _removeAddressRow(int index) {
    setState(() {
      _addresses[index].dispose();
      _addresses.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de nacimiento')),
      );
      return;
    }

    final addrs = _addresses
        .where(
          (a) =>
              a.street.text.trim().isNotEmpty ||
              a.city.text.trim().isNotEmpty ||
              a.country.text.trim().isNotEmpty,
        )
        .map(
          (a) => Address(
            id: null,
            userId: 0, // el repo/DB lo asignará según el user creado
            street: a.street.text.trim(),
            city: a.city.text.trim(),
            country: a.country.text.trim(),
          ),
        )
        .toList();

    final user = User(
      id: null,
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      birthDate: _birthDate!,
      addresses: addrs,
    );

    final cubit = context.read<UsersCubit>();
    await cubit.create(user);

    if (mounted && (cubit.state.error == null)) {
      Navigator.of(context).pop(true); // devuelve true para refrescar lista
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no inyectaste el cubit arriba, puedes hacerlo aquí:
    // return BlocProvider(create: (_) => GetIt.I<UsersCubit>(), child: ...);

    return BlocListener<UsersCubit, UsersState>(
      listenWhen: (p, c) => p.error != c.error && c.error != null,
      listener: (_, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Nuevo usuario')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // NOMBRE
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ej: Juan',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),

                // APELLIDO
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    hintText: 'Ej: Pérez',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),

                // FECHA DE NACIMIENTO
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
                          _birthDate == null
                              ? 'Selecciona una fecha'
                              : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // DIRECCIONES (lista dinámica)
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
                      onPressed: _addAddressRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._addresses.indexed.map((entry) {
                  final index = entry.$1;
                  final item = entry.$2;
                  return _AddressCard(
                    key: ValueKey(item),
                    index: index,
                    ctrls: item,
                    onRemove: () => _removeAddressRow(index),
                  );
                }),

                const SizedBox(height: 24),

                // BOTONES
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
                      label: Text(saving ? 'Guardando...' : 'Guardar'),
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

class _AddressControllers {
  final street = TextEditingController();
  final city = TextEditingController();
  final country = TextEditingController();
  void dispose() {
    street.dispose();
    city.dispose();
    country.dispose();
  }
}

class _AddressCard extends StatelessWidget {
  final int index;
  final _AddressControllers ctrls;
  final VoidCallback onRemove;

  const _AddressCard({
    super.key,
    required this.index,
    required this.ctrls,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar',
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ctrls.street,
              decoration: const InputDecoration(
                labelText: 'Calle/Carrera',
                hintText: 'Ej: Cra 7 # 10-12',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                // No obligatoria si el usuario no quiere agregar ninguna dirección;
                // la validación global filtra filas vacías.
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ctrls.city,
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
                    controller: ctrls.country,
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
