import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/personal_info_model.dart';
import '../models/employment_info_model.dart';
import '../providers/personal_info_provider.dart';
import '../providers/employment_info_provider.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../auth/providers/auth_providers.dart';
import '../../../core/providers/storage_provider.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<ProfileData?> build() async {
    final user = ref.watch(authViewModelProvider.notifier).currentUser;

    if (user == null) return null;

    final personalInfo =
        await ref.watch(personalInfoProvider(user.icNumber).future);
    final employmentInfo =
        await ref.watch(employmentInfoProvider(user.icNumber).future);

    if (personalInfo == null) return null;

    return ProfileData(
      personalInfo: personalInfo,
      employmentInfo: employmentInfo,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authViewModelProvider.notifier).currentUser;
      if (user == null) return null;

      ref.invalidate(personalInfoProvider(user.icNumber));
      ref.invalidate(employmentInfoProvider(user.icNumber));

      final personalInfo =
          await ref.read(personalInfoProvider(user.icNumber).future);
      final employmentInfo =
          await ref.read(employmentInfoProvider(user.icNumber).future);

      if (personalInfo == null) return null;

      return ProfileData(
        personalInfo: personalInfo,
        employmentInfo: employmentInfo,
      );
    });
  }

  Future<void> updateProfilePicture(File imageFile, String icNumber) async {
    final storageService = ref.read(storageServiceProvider);

    final downloadUrl = await storageService.uploadProfilePicture(
      icNumber: icNumber,
      imageFile: imageFile,
    );

    if (downloadUrl == null) {
      throw Exception('Failed to upload profile picture');
    }

    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.updateProfileImage(icNumber, downloadUrl);

    await refresh();
  }
}

class ProfileData {
  final PersonalInfo personalInfo;
  final EmploymentInfo? employmentInfo;

  ProfileData({
    required this.personalInfo,
    this.employmentInfo,
  });
}
