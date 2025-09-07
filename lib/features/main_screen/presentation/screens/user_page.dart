import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:usuarios_direcciones/features/main_screen/domain/entities/user_summary.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_state.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/widgets/user_tile.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Obtiene el cubit desde get_it y carga el listado resumido
      create: (_) => GetIt.I<UsersCubit>()..loadSummaries(),
      child: BlocListener<UsersCubit, UsersState>(
        listenWhen: (p, c) => p.error != c.error && c.error != null,
        listener: (context, state) {
          final msg = state.error!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
          );
        },
        child: const _UsersScaffold(),
      ),
    );
  }
}

class _UsersScaffold extends StatefulWidget {
  const _UsersScaffold();

  @override
  State<_UsersScaffold> createState() => _UsersScaffoldState();
}

class _UsersScaffoldState extends State<_UsersScaffold> {
  Future<void> _refresh(BuildContext context) async {
    await context.read<UsersCubit>().loadSummaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('Usuarios'), elevation: 0),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state.isLoading && state.summaries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.summaries.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('Sin usuarios')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < state.summaries.length; i++) ...[
                        UserTile(
                          summary: state.summaries[i],
                          onEdit: () {
                            _onEditPressed(context, state.summaries[i]);
                          },
                          onDelete: () async {
                            final id = state.summaries[i].id;
                            final ok = await _confirmDelete(context, id);
                            if (ok == true) {
                              //await context.read<UsersCubit>().delete(id);
                              await context.read<UsersCubit>().loadSummaries();
                            }
                          },
                        ),
                        if (i != state.summaries.length - 1)
                          const Divider(height: 1, indent: 72, endIndent: 12),
                      ],
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.pushNamed('add_user');
          if (!mounted) return;
          if (result == true) {
            context.read<UsersCubit>().loadSummaries();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onEditPressed(BuildContext context, UserSummary summary) async {
    final cubit = context.read<UsersCubit>();

    // 1) Loader modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // 2) Cargar usuario completo
    await cubit.loadById(summary.id);

    // 3) Cerrar loader
    if (context.mounted) Navigator.of(context).pop();

    // 4) Error?
    final err = cubit.state.error;
    if (err != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), behavior: SnackBarBehavior.floating),
        );
      }
      return;
    }

    // 5) Navegar a edición
    final user = cubit.state.userSelected;
    if (user == null) return;

    if (context.mounted) {
      final updated = await context.pushNamed('edit_user', extra: user);

      if (updated == true && context.mounted) {
        await cubit.loadSummaries();
      }
    }
  }

  Future<bool?> _confirmDelete(BuildContext context, int id) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: const Text('¿Estás seguro de eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              context.read<UsersCubit>().delete(id);
              Navigator.pop(context, true);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
