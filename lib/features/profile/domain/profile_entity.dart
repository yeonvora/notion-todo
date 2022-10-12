import 'package:equatable/equatable.dart';

/// Entity
class Profile extends Equatable {
  final NotionKey key;

  final String? image;

  final String? title;

  const Profile({
    this.image,
    this.title,
    final NotionKey? key,
  }) : key = key ?? const NotionKey();

  @override
  List<Object?> get props => [
        key,
        image,
        title,
      ];

  Profile copyWith({
    final NotionKey? key,
    final String? image,
    final String? title,
  }) {
    return Profile(
      key: key ?? this.key,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }
}

/// Value-Object
class NotionKey {
  final String token;

  final String databaseId;

  const NotionKey({
    final String? token,
    final String? databaseId,
  })  : token = token ?? '',
        databaseId = databaseId ?? '';
}
