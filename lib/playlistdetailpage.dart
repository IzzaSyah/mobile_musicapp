import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  final String accessToken;

  PlaylistDetailPage({required this.playlistId, required this.accessToken});

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  Map<String, dynamic>? playlistDetail;
  List<dynamic> tracks = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchPlaylistDetail();
  }

  Future<void> fetchPlaylistDetail() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/${widget.playlistId}'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          playlistDetail = json.decode(response.body);
          tracks = playlistDetail!['tracks']['items'];
        });
      } else {
        print('Failed to fetch playlist detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching playlist detail: $error');
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: playlistDetail == null
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
                        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                        title: Text(
                          playlistDetail?['name'] ?? 'Loading...',
                          style: const TextStyle(color: Colors.white),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              playlistDetail!['images'][0]['url'],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: -5, 
                              left: 0, 
                              right: 0, 
                              height: 200, 
                              child: Container(
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
                                      playlistDetail!['images'][0]['url']),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Since 2011',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      playlistDetail!['owner']['display_name'],
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
                                    // Add follow functionality here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 255, 0, 208), 
                                    foregroundColor: const Color.fromARGB(255,255, 246,246), 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Follow +'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Deskripsi playlist
                            Text(
                              playlistDetail!['description'] ??
                                  'No description available',
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Label lagu populer
                            const Text(
                              'Popular Song',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Daftar lagu
                            ListView.builder(
                              shrinkWrap: true,
                              physics:const  NeverScrollableScrollPhysics(),
                              itemCount: tracks.length,
                              itemBuilder: (context, index) {
                                var track = tracks[index]['track'];
                                return ListTile(
                                  leading: Image.network(
                                    track['album']['images'][0]['url'],
                                    width: 50,
                                    height: 50,
                                  ),
                                  title: Text(
                                    track['name'].length > 20
                                        ? track['name'].substring(0, 20) + '...'
                                        : track[
                                            'name'], // Membatasi teks maksimal 20 karakter
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow
                                        .ellipsis, // Tambahkan overflow untuk menampilkan ellipsis jika terlalu panjang
                                  ),
                                  subtitle: Text(
                                    track['artists'][0]['name'],
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    onPressed: toggleFavorite,
                                  ),
                                );
                              },
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
