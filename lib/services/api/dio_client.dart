import 'package:dio/dio.dart';
import 'package:taskflow_mobile/services/storage/secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  Future<String?> _getToken() async {
      final token = await SecureStorage.getToken();
      return token;
    }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        // baseUrl: 'http://localhost:3000/api/',
        baseUrl: 'https://api-task-flow-kappa.vercel.app/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Gestion globale des erreurs
          if (error.response?.statusCode == 401) {
            // logout, refresh token, redirect login, etc.
          }
          handler.next(error);
        }
      ),
    );

    
  }
}
