// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponsePagination<T> _$ApiResponsePaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponsePagination<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiResponsePaginationToJson<T>(
  ApiResponsePagination<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'pagination': instance.pagination,
};
