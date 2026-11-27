# Lab12 — Advanced State Management with BLoC & Cubit

Flutter laboratory project for Narxoz University.

## Included
- AuthCubit with AuthInitial, AuthLoading, AuthSuccess and AuthError
- Equatable immutable states
- Login screen with BlocConsumer
- CartBloc with AddProductEvent, RemoveProductEvent and ClearCartEvent
- Catalog and cart screens with BlocBuilder and live cart badge

## Test credentials
- Email: student@narxoz.kz
- Password: 123456

## Setup
This folder contains the application source and package configuration.
To generate the native Flutter platform folders (android, ios, web, windows, etc.),
open a terminal in this folder and run:

```bash
flutter create .
flutter pub get
flutter run
```

If Flutter platform folders already exist, `flutter create .` is not needed.
