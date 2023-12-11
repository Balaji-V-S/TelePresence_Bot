import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key, required this.vdoPath}) : super(key: key);
  final File vdoPath;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> with WidgetsBindingObserver {
  late CustomVideoPlayerController _customVideoPlayerController;

  late bool isLoading = true;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLocked;
      },
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.white,
          elevation: 50,
          onPressed: () {
            setState(() {
              isLocked = !isLocked;
            });
            if (isLocked) {
              Fluttertoast.showToast(
                  msg: "Screen Locked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                  textColor: Colors.black,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                msg: "Screen Unlocked",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                textColor: Colors.black,
                fontSize: 16.0,
              );
            }
          },
          child: isLocked
              ? const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size:40,
                )
              : const Icon(
                  Icons.lock_open,
                  color: Colors.black,
                  size:40,
                ),
        ),
      ),
    );
  }

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController videoPlayerController =
        VideoPlayerController.file(widget.vdoPath)
          ..initialize().then((value) {
            setState(() {
              isLoading = false;
            });
          });

    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: videoPlayerController);
  }
}



// import 'package:flutter/material.dart';
// import 'package:appinio_video_player/appinio_video_player.dart';

// enum Source { Asset, Network }

// class VideoViewer extends StatefulWidget {
//   const VideoViewer({super.key});

//   @override
//   State<VideoViewer> createState() => _VideoViewerState();
// }

// class _VideoViewerState extends State<VideoViewer> {
//   late CustomVideoPlayerController _customVideoPlayerController;

//   Source currentSource = Source.Asset;

//   Uri videoUri = Uri.parse(
//       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
//   String assetVideoPath = "assets/videos/whale.mp4";

//   late bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     initializeVideoPlayer(currentSource);
//   }

//   @override
//   void dispose() {
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.red,
//               ),
//             )
//           : Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CustomVideoPlayer(
//                   customVideoPlayerController: _customVideoPlayerController,
//                 ),
//                 _sourceButtons(),
//               ],
//             ),
//     );
//   }

//   Widget _sourceButtons() {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         MaterialButton(
//           color: Colors.red,
//           child: const Text(
//             "Network",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           onPressed: () {
//             setState(() {
//               currentSource = Source.Network;
//               initializeVideoPlayer(currentSource);
//             });
//           },
//         ),
//         MaterialButton(
//           color: Colors.red,
//           child: const Text(
//             "Asset",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           onPressed: () {
//             setState(() {
//               currentSource = Source.Asset;
//               initializeVideoPlayer(currentSource);
//             });
//           },
//         ),
//       ],
//     );
//   }

//   void initializeVideoPlayer(Source source) {
//     setState(() {
//       isLoading = true;
//     });
//     VideoPlayerController _videoPlayerController;
//     if (source == Source.Asset) {
//       _videoPlayerController = VideoPlayerController.asset(assetVideoPath)
//         ..initialize().then((value) {
//           setState(() {
//             isLoading = false;
//           });
//         });
//     } else if (source == Source.Network) {
//       _videoPlayerController = VideoPlayerController.networkUrl(videoUri)
//         ..initialize().then((value) {
//           setState(() {
//             isLoading = false;
//           });
//         });
//     } else {
//       return;
//     }
//     _customVideoPlayerController = CustomVideoPlayerController(
//         context: context, videoPlayerController: _videoPlayerController);
//   }
// }
