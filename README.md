# 👥 Gestión de Usuarios con Direcciones

Aplicación Flutter para gestionar usuarios y sus direcciones de forma local, siguiendo principios de **Clean Architecture**, **SOLID** y estructura **feature-first**.

---

## 🚀 Tecnologías principales

- [Flutter](https://flutter.dev/)
- [Bloc / Cubit](https://pub.dev/packages/flutter_bloc) para la gestión de estado
- [Floor](https://pub.dev/packages/floor) (ORM sobre SQLite)
- [get_it](https://pub.dev/packages/get_it) para inyección de dependencias
- [freezed](https://pub.dev/packages/freezed) para modelos inmutables y estados
- [dartz](https://pub.dev/packages/dartz) para manejo funcional de errores (Either)
- [mocktail](https://pub.dev/packages/mocktail) y [bloc_test](https://pub.dev/packages/bloc_test) para testing

---

## 📑 Arquitectura

- **Domain** → Entidades (`User`, `Address`) y contrato de repositorio (`UserRepository`).
- **Data** → Modelos persistibles (`UserModel`, `AddressModel`), DAOs (`UserDao`, `AddressDao`), vistas (`UserWithCount`), e implementación del repositorio (`UserRepositoryImpl`).
- **Application** → Casos de uso (`GetUsers`, `ListUserSummaries`, `CreateUser`, `UpdateUser`, `DeleteUser`, `GetUserById`, `AddAddress`, `RemoveAddress`).
- **Presentation** → Cubit (`UsersCubit`), estados (`UsersState`), y páginas (`UsersPage`, `UserFormPage`, `UserEditPage`).
- **Core** → Base de datos Floor, get_it, manejo de errores.

---

## 🧩 Funcionalidades

- **Listado de usuarios** con número de direcciones.
- **Creación de usuario** con direcciones múltiples.
- **Edición de usuario** con direcciones (agregar/eliminar).
- **Eliminación de usuario** (con borrado en cascada de direcciones).
- **Validaciones de formularios**.
- Manejo de errores centralizado mediante `Failure`.


## 🛠️ Instalación y ejecución

### 1. Instalar dependencias
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

flutter run
```
## 🧩 Pantallazos

<img src="https://raw.githubusercontent.com/megahertzon/usuarios_direcciones/e854b35a40fddbdbbb977fb3a243a0bdc7154379/assets/screenshots/s1.png" width="300"/>

<img src="https://raw.githubusercontent.com/megahertzon/usuarios_direcciones/e854b35a40fddbdbbb977fb3a243a0bdc7154379/assets/screenshots/s2.png" width="300"/>

<img src="https://raw.githubusercontent.com/megahertzon/usuarios_direcciones/e854b35a40fddbdbbb977fb3a243a0bdc7154379/assets/screenshots/s3.png" width="300"/>

<img src="https://raw.githubusercontent.com/megahertzon/usuarios_direcciones/e854b35a40fddbdbbb977fb3a243a0bdc7154379/assets/screenshots/s4.png" width="300"/>