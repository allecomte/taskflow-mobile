class ApiConfig {
  final String baseUrl;

  const ApiConfig({required this.baseUrl});

  static const defaultConfig = ApiConfig(
    baseUrl: 'https://api-task-flow-kappa.vercel.app/api/',
  );
}
