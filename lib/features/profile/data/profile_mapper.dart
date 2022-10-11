import 'dart:convert';
import 'package:noti/features/profile/domain/profile_entity.dart';

class ProfileMapper {
  static String toJson(Profile domain) {
    return json.encode({
      "image": domain.image,
      "title": domain.title,
    });
  }

  static Profile toDomain(String str) {
    final dynamic data = json.decode(str);
    return Profile(
      image: data["image"],
      title: data["title"],
    );
  }
}
