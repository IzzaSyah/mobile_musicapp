import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackDetailPage extends StatefulWidget {
  final String trackId;
  final String accessToken;

  TrackDetailPage({required this.trackId, required this.accessToken});

  @override
  _TrackDetailPageState createState() => _TrackDetailPageState();
}

class _TrackDetailPageState extends State<TrackDetailPage> {
  Map<String, dynamic>? trackDetail;
  String lyrics = "Lyrics not available."; 

  @override
  void initState() {
    super.initState();
    fetchTrackDetail();
    fetchLyrics(); 
  }

  Future<void> fetchTrackDetail() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/tracks/${widget.trackId}'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          trackDetail = json.decode(response.body);
        });
      } else {
        debugPrint('Failed to fetch track detail: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching track detail: $error');
    }
  }

  Future<void> fetchLyrics() async {
    try {
      setState(() {
        lyrics = """
        [Intro]
        La-la-la-la-la

        [Verse 1]
        This is an example lyric
        Here is some text for the song...

        """;
      });
    } catch (error) {
      debugPrint('Error fetching lyrics: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: trackDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 350.0,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                        title: Text(
                          trackDetail?['name'] ?? 'Loading...',
                          style: const TextStyle(color: Colors.white),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gambar album
                            Image.network(
                              trackDetail!['album']['images'][0]['url'],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.transparent,
                                  ],
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
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      trackDetail!['album']['images'][0]['url']),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trackDetail!['artists'][0]['name'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add functionality here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 255, 0, 208),
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 246, 246),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Follow +'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Deskripsi album
                            Text(
                              trackDetail!['album']['name'] ?? 'No album available',
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Lyrics',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              lyrics,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
