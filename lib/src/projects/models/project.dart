import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  factory Project({
    String? title,
    String? description,
    String? ownerUid,
  }) = _Project;
  factory Project.fromJson(Map<String, Object?> json) =>
      _$ProjectFromJson(json);
}
