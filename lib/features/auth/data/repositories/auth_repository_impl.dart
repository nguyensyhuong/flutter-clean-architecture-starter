import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      return await _remoteDataSource.login(email: email, password: password);
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const AuthenticationFailure('Something went wrong');
    }
  }
}
