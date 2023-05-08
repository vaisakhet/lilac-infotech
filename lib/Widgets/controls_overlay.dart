import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  bool isMusicOn = true;

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  void soundToggle() {
    setState(() {
      isMusicOn == true
          ? widget.controller.setVolume(0.0)
          : widget.controller.setVolume(1.0);
      isMusicOn = !isMusicOn;
    });
  }

  getVideoDuration() {
    var duration = Duration(
        milliseconds: widget.controller.value.duration.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: widget.controller.value.isPlaying
                      //? const SizedBox.shrink()
                      ? Container(
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 50.0,
                            semanticLabel: 'pause',
                          ))
                      : Container(
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 50.0,
                            semanticLabel: 'Play',
                          )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 60,
            bottom: 5,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   color: Colors.transparent,
                    //   child: const Icon(
                    //     Icons.skip_previous,
                    //     color: Colors.white,
                    //     size: 30.0,
                    //     semanticLabel: 'Play',
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   color: Colors.transparent,
                    //   child: const Icon(
                    //     Icons.skip_next,
                    //     color: Colors.white,
                    //     size: 30.0,
                    //     semanticLabel: 'Play',
                    //   ),
                    // ),
                    PopupMenuButton<Duration>(
                      initialValue: widget.controller.value.captionOffset,
                      tooltip: 'Caption Offset',
                      onSelected: (Duration delay) {
                        widget.controller.setCaptionOffset(delay);
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<Duration>>[
                          for (final Duration offsetDuration
                              in _exampleCaptionOffsets)
                            PopupMenuItem<Duration>(
                              value: offsetDuration,
                              child: Text('${offsetDuration.inMilliseconds}ms'),
                            )
                        ];
                      },
                      child: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 30.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    PopupMenuButton<double>(
                      initialValue: widget.controller.value.playbackSpeed,
                      tooltip: 'Playback speed',
                      onSelected: (double speed) {
                        widget.controller.setPlaybackSpeed(speed);
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<double>>[
                          for (final double speed in _examplePlaybackRates)
                            PopupMenuItem<double>(
                              value: speed,
                              child: Text('${speed}x'),
                            )
                        ];
                      },
                      child: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 30.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        soundToggle();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          isMusicOn == true
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                          size: 27.0,
                          semanticLabel: 'Play',
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30.0,
                          semanticLabel: 'Play',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 30.0,
                          semanticLabel: 'Play',
                        ),
                      ),

                      /// Position of video in seconds
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 35),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (context, VideoPlayerValue value, child) {
                var currentTime = Duration(
                    milliseconds: widget
                        .controller.value.position.inMilliseconds
                        .round());
                return Text(
                  '${[
                    currentTime.inMinutes,
                    currentTime.inSeconds
                  ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':')} / ${getVideoDuration()}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
