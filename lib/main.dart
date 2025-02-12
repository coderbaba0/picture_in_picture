import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:floating/floating.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final floating = Floating();
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
  String _currentVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  final List<Map<String, String>> videoUrls = [
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'title': 'Big Buck Bunny',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://www.arena-multimedia.com/uploads/blogs/posts/Arena_blog_Whats_the_process_followed_for_creating_an_animated_video_.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'title': 'Elephants Dream',
      'channel': 'Open Movie',
      'thumbnail': 'https://img.freepik.com/free-photo/3d-portrait-little-girl-holding-flower-with-copy-space_23-2151061839.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'title': 'Sintel',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://t3.ftcdn.net/jpg/08/98/83/96/360_F_898839604_7RcqsUoZHOaZNB25DIDh5DwtQyNeAz5U.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'title': 'Big Buck Bunny',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://www.arena-multimedia.com/uploads/blogs/posts/Arena_blog_Whats_the_process_followed_for_creating_an_animated_video_.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'title': 'Elephants Dream',
      'channel': 'Open Movie',
      'thumbnail': 'https://img.freepik.com/free-photo/3d-portrait-little-girl-holding-flower-with-copy-space_23-2151061839.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'title': 'Sintel',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://t3.ftcdn.net/jpg/08/98/83/96/360_F_898839604_7RcqsUoZHOaZNB25DIDh5DwtQyNeAz5U.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'title': 'Big Buck Bunny',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://www.arena-multimedia.com/uploads/blogs/posts/Arena_blog_Whats_the_process_followed_for_creating_an_animated_video_.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'title': 'Elephants Dream',
      'channel': 'Open Movie',
      'thumbnail': 'https://img.freepik.com/free-photo/3d-portrait-little-girl-holding-flower-with-copy-space_23-2151061839.jpg'
    },
    {
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'title': 'Sintel',
      'channel': 'Blender Foundation',
      'thumbnail': 'https://t3.ftcdn.net/jpg/08/98/83/96/360_F_898839604_7RcqsUoZHOaZNB25DIDh5DwtQyNeAz5U.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(_currentVideoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> enablePip(BuildContext context, {bool autoEnable = false}) async {
    final rational = Rational.landscape();
    final screenSize = MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final arguments = autoEnable
        ? OnLeavePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          )
        : ImmediatePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          );

    final status = await floating.enable(arguments);
    debugPrint('PiP enabled? $status');
  }

  void _loadVideo(String url) {
    setState(() {
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          _controller.play();
          setState(() {});
        });
      _currentVideoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: PiPSwitcher(
          childWhenDisabled: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: false,
                  expandedHeight: 250.0, // Fixed height for app bar
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : const Center(child: CircularProgressIndicator()),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_isVideoPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                  _isVideoPlaying = !_isVideoPlaying;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                  
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://video.blender.org/lazy-static/previews/3d95fb3d-c866-42c8-9db1-fe82f48ccb95.jpg', // Placeholder image for channel
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Blender Foundation',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1M subscribers',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              videoUrls[index]['thumbnail']!,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              videoUrls[index]['title']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(videoUrls[index]['channel']!),
                            onTap: () {
                              _loadVideo(videoUrls[index]['url']!);
                            },
                          ),
                        ),
                      );
                    },
                    childCount: videoUrls.length,
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FutureBuilder<bool>(
              future: floating.isPipAvailable,
              initialData: false,
              builder: (context, snapshot) => snapshot.data ?? false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () => enablePip(context),
                          label: const Text('Enable PiP'),
                          icon: const Icon(Icons.picture_in_picture),
                        ),
                        const SizedBox(height: 12),
                        FloatingActionButton.extended(
                          onPressed: () => enablePip(context, autoEnable: true),
                          label: const Text('On Minimize'),
                          icon: const Icon(Icons.auto_awesome),
                        ),
                      ],
                    )
                  : const Card(
                      child: Text('PiP unavailable'),
                    ),
            ),
          ),
          childWhenEnabled: VideoPlayer(_controller),
        ),
      );
}
