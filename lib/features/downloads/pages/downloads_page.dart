import 'package:bunpod/bunpod.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter/material.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _Body(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const StyledBackButton(),
      title: const Text('Downloads'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  // TODO(kamran): testing only — fakes each download in the queue completing
  // over five seconds, moving it to the on-device section and starting the
  // next one.
  int _fakeCompleted = 0;

  /// Episodes whose downloads were removed this session — mock persistence
  /// until real download storage lands.
  final Set<Episode> _deleted = {};

  /// Episodes mid removal animation: still in the list, playing their
  /// collapse. Moved to [_deleted] when the tile reports its slot closed.
  final Set<Episode> _removing = {};

  void _startRemoving(Iterable<Episode> episodes) {
    setState(() => _removing.addAll(episodes));
  }

  void _finishRemoving(Episode episode) {
    setState(() {
      _removing.remove(episode);
      _deleted.add(episode);
    });
  }

  late final AnimationController _fakeDownload =
      AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
        )
        ..addListener(() => setState(() {}))
        ..addStatusListener(_onFakeDownloadDone)
        ..forward();

  void _onFakeDownloadDone(AnimationStatus status) {
    if (status != .completed) return;

    final int queueLength = mockDownloads.where((d) => d.state != .done).length;

    setState(() => _fakeCompleted++);
    if (_fakeCompleted < queueLength) {
      _fakeDownload
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _fakeDownload.dispose();
    super.dispose();
  }

  // Mock-only: holds the expressive indicator for a beat; a real download
  // sync goes here later.
  Future<void> _refresh() {
    return Future<void>.delayed(const Duration(milliseconds: 1500));
  }

  Future<void> _clearPlayed(
    BuildContext context,
    List<Download> played,
    int megabytes,
  ) async {
    final bool confirmed = await StyledSheet.show(
      context,
      icon: Icons.delete_sweep_rounded,
      title: 'Clear played episodes?',
      message:
          'Removes ${played.length} episodes you finished and frees '
          '${sizeLabel(megabytes)} on this device. You can download '
          'them again anytime.',
      confirmLabel: 'Free up ${sizeLabel(megabytes)}',
    );

    if (confirmed && context.mounted) {
      _startRemoving(played.map((d) => d.episode));
      showExpressiveSnack(
        context: context,
        message: '${sizeLabel(megabytes)} freed',
        icon: Icons.delete_sweep_rounded,
      );
    }
  }

  Future<void> _deleteOne(BuildContext context, Download download) async {
    final String size = sizeLabel(download.megabytes);

    final bool confirmed = await StyledSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: 'Remove download?',
      message:
          'Removes "${download.episode.title}" from this device and frees '
          '$size. You can download it again anytime.',
      confirmLabel: 'Free up $size',
      destructive: true,
    );

    if (confirmed && context.mounted) {
      _startRemoving([download.episode]);
      showExpressiveSnack(
        context: context,
        message: '$size freed',
        icon: Icons.delete_outline_rounded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final List<Download> downloadQueue = mockDownloads
        .where((d) => d.state != .done && !_deleted.contains(d.episode))
        .toList();

    final List<Download> queue = [];
    final List<Download> onDevice = [];
    final List<Download> played = [];

    // Testing only: the first _fakeCompleted queue entries are finished and
    // live on device, the next one is actively downloading with the fake
    // timer's progress, and the rest wait in line.
    for (int i = 0; i < downloadQueue.length; i++) {
      final Download download = downloadQueue[i];

      if (i < _fakeCompleted) {
        onDevice.add(
          Download(episode: download.episode, megabytes: download.megabytes),
        );
      } else if (i == _fakeCompleted) {
        queue.add(
          Download(
            episode: download.episode,
            megabytes: download.megabytes,
            received: (download.megabytes * _fakeDownload.value).round(),
            state: .downloading,
          ),
        );
      } else {
        queue.add(
          Download(
            episode: download.episode,
            megabytes: download.megabytes,
            state: .queued,
          ),
        );
      }
    }

    for (final Download download in mockDownloads) {
      if (download.state != .done) continue;
      if (_deleted.contains(download.episode)) continue;
      (download.played ? played : onDevice).add(download);
    }

    final int onDeviceMB = onDevice.fold(0, (sum, d) => sum + d.megabytes);
    final int playedMB = played.fold(0, (sum, d) => sum + d.megabytes);

    DownloadTile tile(Download download) {
      return DownloadTile(
        // Keyed so a mid-removal tile keeps its animation state when rows
        // before it leave the list.
        key: ValueKey(download.episode),
        download: download,
        onTap: () {
          Navigator.of(context).push(PlayerPage.route(download.episode));
        },
        onDelete: download.state == .done
            ? () => _deleteOne(context, download)
            : null,
        removing: _removing.contains(download.episode),
        onRemoved: () => _finishRemoving(download.episode),
      );
    }

    return ExpressiveRefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: .fromLTRB(
          16,
          16,
          16,
          BottomPadding.of(context),
        ),
        children: [
          if (queue.isNotEmpty) ...[
            DownloadSection(
              label: 'Downloading',
              children: [
                for (final Download download in queue) tile(download),
              ],
            ),
            32.gap,
          ],
          DownloadSection(
            label: 'On device',
            meta: sizeLabel(onDeviceMB),
            children: [
              for (final Download download in onDevice) tile(download),
            ],
          ),
          if (played.isNotEmpty) ...[
            32.gap,
            DownloadSection(
              label: 'Played',
              action: FilledButton.tonal(
                onPressed: () {
                  _clearPlayed(context, played, playedMB);
                },
                style: FilledButton.styleFrom(
                  visualDensity: .compact,
                  textStyle: tt.labelMedium,
                  padding: const .symmetric(horizontal: 12),
                ),
                child: Text('Free up ${sizeLabel(playedMB)}'),
              ),
              children: [
                for (final Download download in played) tile(download),
              ],
            ),
          ],
          24.gap,
          Center(
            child: TextButton.icon(
              onPressed: () {
                ComingSoon.show(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: cs.onSurfaceVariant,
                textStyle: tt.labelMedium,
              ),
              icon: const Icon(Icons.auto_delete_outlined, size: 18),
              label: const Text('Auto-delete played episodes: after 30 days'),
            ),
          ),
        ],
      ),
    );
  }
}
