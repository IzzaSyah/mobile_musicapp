import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArtistDetailPage extends StatefulWidget {
  final String artistId;
  final String accessToken;

  ArtistDetailPage({required this.artistId, required this.accessToken});

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  Map<String, dynamic>? artistDetail;
  List<dynamic> topTracks = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchArtistDetail();
  }

  Future<void> fetchArtistDetail() async {
    try {
      // Fetch detail artis dari Spotify API
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/artists/${widget.artistId}'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          artistDetail = json.decode(response.body);
        });
      } else {
        print('Failed to fetch artist detail: ${response.statusCode}');
      }

      // Fetch top tracks artis dari Spotify API
      final topTracksResponse = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/artists/${widget.artistId}/top-tracks?market=US'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (topTracksResponse.statusCode == 200) {
        setState(() {
          topTracks = json.decode(topTracksResponse.body)['tracks'];
        });
      } else {
        print('Failed to fetch top tracks: ${topTracksResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching artist detail: $error');
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
      body: artistDetail == null
          ? Center(child: CircularProgressIndicator())
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
                      expandedHeight: 350.0, // Tinggi gambar
                      pinned: true, // app bar ada meski di scroll
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                        title: Text(
                          artistDetail?['name'] ?? 'Loading...',
                          style: const TextStyle(color: Colors.white),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gambar artis
                            if (artistDetail!['images'] != null &&
                                artistDetail!['images'].isNotEmpty)
                              Image.network(
                                artistDetail!['images'][0]['url'],
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
                            // Informasi profil artis
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      artistDetail!['images'][0]['url']),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Genres: ${artistDetail!['genres'].join(', ')}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      artistDetail!['name'],
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
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 255, 0, 208),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Follow +'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Popularitas artis
                            Text(
                              'Popularity: ${artistDetail!['popularity']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Top Tracks',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Daftar top tracks artis
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: topTracks.length,
                              itemBuilder: (context, index) {
                                var track = topTracks[index];
                                return ListTile(
                                  leading: Image.network(
                                    track['album']['images'][0]['url'],
                                    width: 50,
                                    height: 50,
                                  ),
                                  title: Text(
                                    track['name'].length > 20
                                        ? track['name'].substring(0, 20) + '...'
                                        : track['name'],
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'Album: ${track['album']['name']}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.white,
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
