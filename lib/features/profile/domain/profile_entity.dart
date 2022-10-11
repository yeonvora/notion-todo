/// Entity
class Profile {
  final String? image;

  final String? title;

  const Profile({
    this.image,
    this.title,
  });

  Profile copyWith({
    final String? image,
    final String? title,
  }) {
    return Profile(
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }
}
