import '../../features/auth/data/models/user_model.dart';
import '../constants/app_strings.dart';
import '../error/failure.dart';

class MockAuthApiService {
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (email.trim().toLowerCase() == 'demo@clean.dev' &&
        password == '123456') {
      return const UserModel(
        id: '1',
        name: 'Demo User',
        email: 'demo@clean.dev',
        token: 'mock-token-abc-123',
      );
    }

    throw const AuthenticationFailure(AppStrings.invalidCredentials);
  }
}
