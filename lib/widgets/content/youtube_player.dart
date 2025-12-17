import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// YouTube video player widget with controls
class ChapterYoutubePlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool isChildFriendly;

  const ChapterYoutubePlayer({
    super.key,
    required this.videoId,
    this.autoPlay = false,
    this.isChildFriendly = false,
  });

  @override
  State<ChapterYoutubePlayer> createState() => _ChapterYoutubePlayerState();
}

class _ChapterYoutubePlayerState extends State<ChapterYoutubePlayer> {
  late YoutubePlayerController _controller;
  bool _isReady = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        enableCaption: true,
        forceHD: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        disableDragSeek: widget.isChildFriendly,
      ),
    );

    _controller.addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.unicefBlue,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.unicefBlue,
          handleColor: AppColors.unicefBlue,
        ),
        onReady: () {
          setState(() {
            _isReady = true;
          });
        },
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: AppColors.unicefBlue,
              handleColor: AppColors.unicefBlue,
            ),
          ),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Column(
          children: [
            // Player container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.isChildFriendly
                      ? AppDimensions.radiusLg
                      : AppDimensions.radiusMd,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  widget.isChildFriendly
                      ? AppDimensions.radiusLg
                      : AppDimensions.radiusMd,
                ),
                child: Stack(
                  children: [
                    player,
                    if (!_isReady)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: AppColors.surfaceGray,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.unicefBlue,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Thumbnail placeholder for video before loading
class VideoThumbnailPlaceholder extends StatelessWidget {
  final String videoId;
  final VoidCallback? onTap;
  final bool isChildFriendly;

  const VideoThumbnailPlaceholder({
    super.key,
    required this.videoId,
    this.onTap,
    this.isChildFriendly = false,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = YoutubePlayer.getThumbnail(
      videoId: videoId,
      quality: ThumbnailQuality.high,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            isChildFriendly
                ? AppDimensions.radiusLg
                : AppDimensions.radiusMd,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            isChildFriendly
                ? AppDimensions.radiusLg
                : AppDimensions.radiusMd,
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.surfaceGray,
                      child: const Center(
                        child: Icon(
                          Icons.video_library,
                          size: 48,
                          color: AppColors.textMedium,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.surfaceGray,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.unicefBlue,
                        ),
                      ),
                    );
                  },
                ),
                // Dark overlay
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                // Play button
                Center(
                  child: Container(
                    width: isChildFriendly ? 80 : 64,
                    height: isChildFriendly ? 80 : 64,
                    decoration: BoxDecoration(
                      color: AppColors.unicefBlue.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: isChildFriendly ? 48 : 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
