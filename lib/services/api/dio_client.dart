import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/api/api_config.dart';
import 'package:taskflow_mobile/services/storage/secure_storage.dart';

class DioClient {
  final Dio dio;

  DioClient({
    ApiConfig? config
  }) : dio = Dio(
          BaseOptions(
            baseUrl: (config ?? ApiConfig.defaultConfig).baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // logout / refresh token
          }
          handler.next(error);
        },
      ),
    );
  } 
}
