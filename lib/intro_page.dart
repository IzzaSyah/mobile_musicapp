import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_page.dart';
import 'dart:async';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late VideoPlayerController _controller;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Memutar video dari asset lokal
    _controller = VideoPlayerController.asset(
      'assets/videos/bgvideo.mp4',
    )
      ..initialize().then((_) {
        _controller.setLooping(true); 
        _controller.play(); 
        setState(() {});
      });

    // Timer pindah halaman
    _startProgress();

    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  // progress bar
  void _startProgress() {
    Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      setState(() {
        _progressValue += 0.15;
        if (_progressValue >= 1.0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
          _controller.value.isInitialized
              ? SizedBox.expand( 
                  child: FittedBox(
                    fit: BoxFit.cover, 
                    child: SizedBox(
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()), 

          // Konten di atas video
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                const SizedBox(height: 40), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20), 
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)), 
                    child: LinearProgressIndicator(
                      value: _progressValue, 
                      minHeight: 3, 
                      backgroundColor: Colors.white.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 0, 208),),
                    ),
                  ),
                ),
                const SizedBox(height: 40), 

                const Text(
                  'Enjoy Your\nMusic, Enjoy\nYour Life',
                  textAlign: TextAlign.left, 
                  style: TextStyle(
                    
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), 
                const Text(
                  'Listen to your favorite music for free,\nanywhere and offline with GemPlay.',
                  textAlign: TextAlign.left, 
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 50), 
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 0, 208),
                    foregroundColor: const Color.fromARGB(255, 252, 252, 252),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Text('Start Listening'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
