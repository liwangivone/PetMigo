import '../services/auth_services.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthServices _authServices = AuthServices();

  Future<User> login(String email, String password) {
    return _authServices.login(email, password);
  }

  Future<User> register(String name, String email, String password) {
    return _authServices.register(name, email, password);
  }
}