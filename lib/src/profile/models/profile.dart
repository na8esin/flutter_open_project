import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  factory Profile({
    String? nickname,
    String? photoUrl,
  }) = _Profile;
  factory Profile.fromJson(Map<String, Object?> json) =>
      _$ProfileFromJson(json);
}
