import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/controls_overlay.dart';
import '../Widgets/drawer_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  late Future<void> _initializeVideoPlayerFuture;

  bool isMusicOn = true;

  var count = 3;

  // List<String> VideoUrl = [
  //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  //   'https://download.samplelib.com/mp4/sample-15s.mp4',
  //   'https://download.samplelib.com/mp4/sample-20s.mp4',
  //   'https://download.samplelib.com/mp4/sample-30s.mp4',
  // ];

  Future downloader(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: baseStorage!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    /// video Player
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.videoPlayerOptions?.allowBackgroundPlayback;

    /// video Downloader

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print("Download completed");
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }

  @override
  void dispose() {
    /// video Player

    _controller.dispose();

    /// video Downloader

    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-260nw-1714666150.jpg"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // child: VideoPlayer(_controller),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_controller),
                            ClosedCaption(text: _controller.value.caption.text),
                            ControlsOverlay(controller: _controller),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 65, right: 55, bottom: 40),
                              child: VideoProgressIndicator(_controller,
                                  padding: const EdgeInsets.only(right: 40),
                                  colors: const VideoProgressColors(
                                    playedColor: Color(0xff57EE9D),
                                    backgroundColor: Color(0xff525252),
                                    bufferedColor: Color(0xff525252),
                                  ),
                                  allowScrubbing: true),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Previews Button
              GestureDetector(
                onTap: () {
                  print('previes Button');
                  setState(() {
                    //count == 0 ? null :
                    count--;
                  });
                },
                child: PhysicalModel(
                  color: Theme.of(context).backgroundColor,
                  elevation: 8,
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  child: const SizedBox(
                    height: 60,
                    width: 60,
                    child: Center(
                        child: Icon(
                      Icons.arrow_left,
                      size: 45,
                      color: Colors.black,
                    )),
                  ),
                ),
              ),

              /// Downloade button
              GestureDetector(
                onTap: () {
                  downloader(
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');

                  const text = 'Start Downloading';

                  final snackBar =
                      SnackBar(content: Center(child: const Text(text)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar,
                  );
                },
                child: PhysicalModel(
                  color: Theme.of(context).backgroundColor,
                  elevation: 8,
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 60,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_downward,
                          size: 40,
                          color: Colors.green,
                        ),
                        Text(
                          'Download',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              /// Next Button
              GestureDetector(
                onTap: () {
                  print('Next Button');
                  setState(() {
                    //VideoUrl.length == count ? null :
                    count++;
                  });
                },
                child: PhysicalModel(
                  color: Theme.of(context).backgroundColor,
                  elevation: 8,
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  child: const SizedBox(
                    height: 60,
                    width: 60,
                    child: Center(
                        child: Icon(
                      Icons.arrow_right,
                      size: 45,
                      color: Colors.black,
                    )),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
