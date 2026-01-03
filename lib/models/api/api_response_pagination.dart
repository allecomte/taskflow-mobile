import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/api/pagination.dart';

part 'api_response_pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponsePagination<T> {
  List<T> data = [];
  Pagination pagination;

  ApiResponsePagination({required this.data, required this.pagination});

  factory ApiResponsePagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponsePaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponsePaginationToJson(this, toJsonT);
}
