import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:usuarios_direcciones/core/di/sl.dart';
import 'package:usuarios_direcciones/features/add_user/presentation/screens/user_form_page.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/screens/user_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/cubit/users_cubit.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => UsersPage()),
    GoRoute(
      path: '/add_user',
      name: 'add_user',
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<UsersCubit>(),
        child: const UserFormPage(),
      ),
    ),
    // Puedes agregar más rutas aquí
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocatorInit();
  runApp(
    MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'), // Español
        const Locale('en'), // Inglés
      ],
    ),
  );
}
