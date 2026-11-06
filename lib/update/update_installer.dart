import 'package:ota_update/ota_update.dart';

import 'update_checker.dart';

/// Progress of downloading and handing the APK to the Android installer.
sealed class InstallProgress {
  const InstallProgress();
}

class Downloading extends InstallProgress {
  const Downloading(this.percent);

  /// 0-100, or null while the size is unknown.
  final int? percent;
}

/// The system installer is open; Android takes over from here.
class InstallerOpened extends InstallProgress {
  const InstallerOpened();
}

class InstallFailed extends InstallProgress {
  const InstallFailed(this.reason);

  final InstallFailure reason;
}

enum InstallFailure {
  permissionNeeded,
  downloadFailed,
  canceled,
  alreadyRunning,
  unknown,
}

/// Downloads the update and opens the Android installer.
///
/// The user always confirms the installation; Android only accepts it if
/// the APK is signed with the same key as the installed app.
class UpdateInstaller {
  Stream<InstallProgress> install(AvailableUpdate update) {
    return OtaUpdate()
        .execute(
          update.apkUrl.toString(),
          destinationFilename: 'nem-a-pato-bullet-update.apk',
        )
        .map(_toProgress);
  }

  InstallProgress _toProgress(OtaEvent event) {
    return switch (event.status) {
      OtaStatus.DOWNLOADING => Downloading(int.tryParse(event.value ?? '')),
      OtaStatus.INSTALLING ||
      OtaStatus.INSTALLATION_DONE => const InstallerOpened(),
      OtaStatus.PERMISSION_NOT_GRANTED_ERROR => const InstallFailed(
        InstallFailure.permissionNeeded,
      ),
      OtaStatus.DOWNLOAD_ERROR => const InstallFailed(
        InstallFailure.downloadFailed,
      ),
      OtaStatus.CANCELED => const InstallFailed(InstallFailure.canceled),
      OtaStatus.ALREADY_RUNNING_ERROR => const InstallFailed(
        InstallFailure.alreadyRunning,
      ),
      _ => const InstallFailed(InstallFailure.unknown),
    };
  }
}
