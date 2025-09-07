import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:usuarios_direcciones/core/di/sl.dart';
import 'package:usuarios_direcciones/features/add_user/presentation/screens/user_form_page.dart';
import 'package:usuarios_direcciones/features/users_screen/presentation/screens/user_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuarios_direcciones/features/users_screen/presentation/cubit/users_cubit.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/user.dart';
import 'package:usuarios_direcciones/inherited_theme_mode_notifier.dart';

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
    GoRoute(
      path: '/edit_user',
      name: 'edit_user',
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<UsersCubit>(),
        child: UserFormPage(userToEdit: state.extra as User),
      ),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocatorInit();
  final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  runApp(MyApp(themeModeNotifier: themeModeNotifier));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const MyApp({super.key, required this.themeModeNotifier});

  @override
  Widget build(BuildContext context) {
    return InheritedThemeModeNotifier(
      notifier: themeModeNotifier,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, mode, _) {
          return MaterialApp.router(
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: Brightness.light,
              fontFamily: 'Roboto',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              cardTheme: const CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.indigo,
              fontFamily: 'Roboto',
            ),
            themeMode: mode,
            localizationsDelegates: [
              CountryLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('es'), // Español
              const Locale('en'), // Inglés
            ],
          );
        },
      ),
    );
  }
}
