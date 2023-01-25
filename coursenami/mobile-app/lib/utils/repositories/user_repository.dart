import '../../models/user/user_model.dart';
import '../clients/api_clients.dart';

class UserRepository{
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<UserModel> getUser() async {
    return await apiClient.get<UserModel>(path: 'auth/user');
  }
}
