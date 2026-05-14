import '../../../../core/network/mock_auth_api_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService);

  final MockAuthApiService _apiService;

  @override
  Future<UserModel> login({required String email, required String password}) {
    return _apiService.login(email: email, password: password);
  }
}
