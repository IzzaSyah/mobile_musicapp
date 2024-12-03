import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'spotify_service.dart';
import 'playlistdetailpage.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<dynamic> personalPlaylists = [];
  List<dynamic> publicPlaylists = [];
  List<dynamic> favoriteTracks = [];
  late SpotifyService spotifyService;

  @override
  void initState() {
    super.initState();
    spotifyService = SpotifyService();
    fetchLibraryData();
  }

  Future<void> fetchLibraryData() async {
    try {
      String accessToken = await spotifyService.getAccessToken();

      // Fetch personal playlists
      final personalResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/playlists'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (personalResponse.statusCode == 200) {
        setState(() {
          personalPlaylists = json.decode(personalResponse.body)['items'];
        });
      } else {
        print('Failed to fetch personal playlists: ${personalResponse.statusCode}');
      }

      // Fetch public playlists
      final publicResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/browse/featured-playlists'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (publicResponse.statusCode == 200) {
        setState(() {
          publicPlaylists = json.decode(publicResponse.body)['playlists']['items'];
        });
      } else {
        print('Failed to fetch public playlists: ${publicResponse.statusCode}');
      }

      // Fetch favorite tracks
      final favoriteResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (favoriteResponse.statusCode == 200) {
        setState(() {
          favoriteTracks = json.decode(favoriteResponse.body)['items'];
        });
      } else {
        print('Failed to fetch favorite tracks: ${favoriteResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching library data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // Library Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  const SizedBox(height: 15),

                  // Personal Playlists Section
                  const Text(
                    'Your Playlists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  personalPlaylists.isEmpty
                      ? const Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: personalPlaylists.length,
                          itemBuilder: (context, index) {
                            final playlist = personalPlaylists[index];
                            return GestureDetector(
                              onTap: () async {
                                String accessToken =
                                    await spotifyService.getAccessToken();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaylistDetailPage(
                                      playlistId: playlist['id'],
                                      accessToken: accessToken,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      playlist['images'].isNotEmpty
                                          ? playlist['images'][0]['url']
                                          : 'https://via.placeholder.com/80',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    playlist['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 15),

                  // Public Playlists Section
                  const Text(
                    'Public Playlists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  publicPlaylists.isEmpty
                      ? const Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: publicPlaylists.length,
                          itemBuilder: (context, index) {
                            final playlist = publicPlaylists[index];
                            return GestureDetector(
                              onTap: () async {
                                String accessToken =
                                    await spotifyService.getAccessToken();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaylistDetailPage(
                                      playlistId: playlist['id'],
                                      accessToken: accessToken,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      playlist['images'].isNotEmpty
                                          ? playlist['images'][0]['url']
                                          : 'https://via.placeholder.com/80',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    playlist['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 15),

                  // Favorite Tracks Section
                  const Text(
                    'Favorite Tracks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  favoriteTracks.isEmpty
                      ? const Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: favoriteTracks.length,
                          itemBuilder: (context, index) {
                            final track = favoriteTracks[index]['track'];
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    track['album']['images'][0]['url'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  track['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
