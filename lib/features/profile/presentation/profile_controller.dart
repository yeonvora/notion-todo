import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/profile/domain/profile_entity.dart';
import 'package:noti/features/profile/domain/profile_service.dart';

typedef ProfileState = Profile;

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileUsecase profileUsecase;

  ProfileController(this.profileUsecase) : super(const Profile()) {
    loadProfile();
  }

  /// 프로필 불러오기
  void loadProfile() {
    state = profileUsecase.getProfile();
  }

  /// 배경 이미지 변경
  void changeBackground(String image) {
    profileUsecase.changeBackground(image);
    state = profileUsecase.getProfile();
  }

  /// 제목 수정
  void editTitle(String title) {
    profileUsecase.editTitle(title);
    state = profileUsecase.getProfile();
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ref.watch(profileServiceProvider));
});
