import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_dialog.dart';
import '../ui/widgets/app_message.dart';
import '../ui/widgets/train_progress_bar.dart';
import 'update_checker.dart';
import 'update_installer.dart';

/// "Nova versão disponível" dialog. If the user accepts, shows the
/// download progress until the Android installer opens.
Future<void> showUpdateDialog(
  BuildContext context, {
  required AvailableUpdate update,
  required UpdateInstaller installer,
}) async {
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) => AppDialog(
      title: context.l10n.updateDialogTitle,
      actions: [
        DialogButton(
          label: context.l10n.update,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        DialogButton(
          label: context.l10n.later,
          primary: false,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.updateDialogBody(update.version.label),
            textAlign: TextAlign.center,
          ),
          // GitHub release notes are written in English, so they stay
          // collapsed; the text above is what the players read.
          if (update.notes.isNotEmpty) _ReleaseNotes(notes: update.notes),
        ],
      ),
    ),
  );
  if (!(accepted ?? false) || !context.mounted) return;

  final failure = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _DownloadDialog(progress: installer.install(update)),
  );
  if (failure != null && context.mounted) {
    showAppMessage(context, failure, duration: const Duration(seconds: 8));
  }
}

/// "Release notes >" link that expands the notes from the GitHub release.
class _ReleaseNotes extends StatefulWidget {
  const _ReleaseNotes({required this.notes});

  final String notes;

  @override
  State<_ReleaseNotes> createState() => _ReleaseNotesState();
}

class _ReleaseNotesState extends State<_ReleaseNotes> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.releaseNotes.toUpperCase(),
                    style: AppTextStyles.cardLabel,
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: AppColors.cardMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardDivider, width: 2),
            ),
            child: Text(
              widget.notes,
              style: AppDialog.bodyStyle.copyWith(
                fontSize: 12,
                color: AppColors.cardMuted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Pops with null once the installer opens, or with an error message.
class _DownloadDialog extends StatefulWidget {
  const _DownloadDialog({required this.progress});

  final Stream<InstallProgress> progress;

  @override
  State<_DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<_DownloadDialog> {
  StreamSubscription<InstallProgress>? _subscription;
  int? _percent;

  @override
  void initState() {
    super.initState();
    _subscription = widget.progress.listen(
      (event) {
        switch (event) {
          case Downloading(:final percent):
            setState(() => _percent = percent);
          case InstallerOpened():
            _close(null);
          case InstallFailed(:final reason):
            _close(_failureMessage(reason));
        }
      },
      onError: (Object _) {
        if (mounted) _close(context.l10n.updateDownloadFailed);
      },
    );
  }

  String _failureMessage(InstallFailure reason) {
    final l10n = context.l10n;
    return switch (reason) {
      InstallFailure.permissionNeeded => l10n.installPermissionNeeded,
      InstallFailure.downloadFailed => l10n.updateDownloadFailed,
      InstallFailure.canceled => l10n.updateCanceled,
      InstallFailure.alreadyRunning => l10n.updateAlreadyRunning,
      InstallFailure.unknown => l10n.updateInstallFailed,
    };
  }

  void _close(String? failure) {
    _subscription?.cancel();
    _subscription = null;
    if (mounted) Navigator.of(context).pop(failure);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = _percent;

    // No buttons: the dialog closes by itself when the installer opens.
    return AppDialog(
      title: context.l10n.downloadingUpdate,
      child: Column(
        children: [
          TrainProgressBar(
            progress: (percent ?? 0) / 100,
            color: AppColors.ink,
          ),
          const SizedBox(height: 14),
          Text(
            percent == null ? context.l10n.startingDownload : '$percent%',
            style: AppTextStyles.category,
          ),
        ],
      ),
    );
  }
}
