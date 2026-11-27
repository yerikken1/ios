import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    await Future.delayed(const Duration(seconds: 2));

    if (email == 'student@narxoz.kz' && password == '123456') {
      emit(
        AuthSuccess(
          username: 'Student',
          email: email,
        ),
      );
    } else {
      emit(const AuthError('Invalid email or password'));
    }
  }
}
