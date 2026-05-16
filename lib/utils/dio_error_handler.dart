import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:taskflow_mobile/services/api/api_exception.dart';

String _extractMessage(
  DioException e, {
  String fallback = 'Une erreur est survenue',
  List<String> errorKeys = const ['error', 'message', 'detail'],
}) {
  final data = e.response?.data;
  Map<String, dynamic>? json;

  if (data is Map<String, dynamic>) {
    json = data;
  } else if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) json = decoded;
    } catch (_) {
      return data;
    }
  }

  if (json != null) {
    for (final key in errorKeys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
    }
  }

  return e.message ?? fallback;
}

/// Lève toujours une ApiException — le type de retour Never
/// indique au compilateur Dart que la fonction ne retourne jamais normalement,
/// ce qui évite d'avoir à mettre un return fictif après l'appel.
Never throwDioException(
  DioException e, {
  String fallback = 'Une erreur est survenue',
  List<String> errorKeys = const ['error', 'message', 'detail'],
}) {
  throw ApiException(
    _extractMessage(e, fallback: fallback, errorKeys: errorKeys),
    statusCode: e.response?.statusCode,
  );
}