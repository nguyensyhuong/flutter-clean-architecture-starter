import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) {
    if (email.trim().isEmpty) {
      throw const ValidationFailure(AppStrings.emptyEmail);
    }

    if (password.trim().isEmpty) {
      throw const ValidationFailure(AppStrings.emptyPassword);
    }

    return _repository.login(email: email, password: password);
  }
}
