
import 'package:yatru_sewa/shared/clients/api_client.dart';
import 'package:yatru_sewa/shared/models/models.dart';

class UserRepository {

  final ApiClient apiClient;

  UserRepository({
    required this.apiClient,
  });

  Future<User> getUser() async {
    
    return await apiClient.get<User>(
      path: 'auth/user'
    );
  }
}