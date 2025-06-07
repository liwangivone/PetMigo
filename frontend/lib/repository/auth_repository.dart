import '../services/auth_services.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthServices _authServices = AuthServices();

  Future<User> login(String email, String password) async {
    try {
      return await _authServices.login(email, password);
    } catch (e) {
      // Re-throw dengan pesan yang lebih user-friendly jika perlu
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      return await _authServices.register(name, email, password);
    } catch (e) {
      // Re-throw dengan pesan yang lebih user-friendly jika perlu
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }
}