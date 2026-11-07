import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/errors/failures.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology_provider.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/repositories/auth_repository.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  error,
}

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.auth,
  });

  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final LoginStatus status;
  final String? errorMessage;
  final Auth? auth;

  bool get isLoading => status == LoginStatus.loading;
  bool get hasError => status == LoginStatus.error;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    LoginStatus? status,
    String? errorMessage,
    Auth? auth,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      auth: auth ?? this.auth,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isPasswordVisible,
        rememberMe,
        status,
        errorMessage,
        auth,
      ];
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(() {
  return LoginNotifier();
});

class LoginNotifier extends Notifier<LoginState> {
  late final AuthRepository _repository;

  @override
  LoginState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const LoginState();
  }

  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String pwd) => state = state.copyWith(password: pwd);
  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  void toggleRememberMe() =>
      state = state.copyWith(rememberMe: !state.rememberMe);

  Future<bool> signIn() async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      final auth = await _repository.login(state.email, state.password);
      if (auth.defaultOrganisationCode.isNotEmpty) {
        ref.read(currentOrgCodeProvider.notifier).state =
            auth.defaultOrganisationCode;
      }
      state = state.copyWith(status: LoginStatus.success, auth: auth);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.logout();
    ref.read(currentOrgCodeProvider.notifier).state = null;
    state = const LoginState();
  }
}

