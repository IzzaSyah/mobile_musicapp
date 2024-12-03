import 'package:flutter/material.dart';
import 'spotify_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'account_page.dart';
import 'playlistdetailpage.dart';
import 'artisdetailpage.dart';
import 'trackdetailpage.dart';
import 'searchpage.dart';
import 'librarypages.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> playlists = [];
  List<dynamic> popularArtists = [];
  List<dynamic> recentlyPlayed = [];
  late SpotifyService spotifyService;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    spotifyService = SpotifyService(); // Inisialisasi SpotifyService
    fetchData(); // Panggil API saat aplikasi dimulai
  }

  Future<void> fetchData() async {
    try {
      // Dapatkan Access Token dari SpotifyService
      String accessToken = await spotifyService.getAccessToken();
      print('Access Token: $accessToken'); // Log access token

      // Fetch playlists menggunakan Search API
      // final playlistResponse = await http.get(
      //   Uri.parse('https://api.spotify.com/v1/search?q=GMMTV&type=playlist'),
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      final playlistResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=trend&type=playlist'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Log status code dan body dari API Playlist
      if (playlistResponse.statusCode == 200) {
        print('Playlist Data: ${playlistResponse.body}');
        setState(() {
          playlists = json.decode(playlistResponse.body)['playlists']['items'];
        });
      } else {
        print('Failed Playlist Response: ${playlistResponse.statusCode}');
        print('Failed Playlist Response Body: ${playlistResponse.body}');
      }

      // Fetch popular artists menggunakan Search API
      // final artistResponse = await http.get(
      //   Uri.parse(
      //       'https://api.spotify.com/v1/search?q=genre:thai&type=artist&market=TH'),
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      final artistResponse = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=genre:K-pop&type=artist&market=KR&limit=30'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // API Artist
      if (artistResponse.statusCode == 200) {
        print('Artist Data: ${artistResponse.body}');
        setState(() {
          popularArtists = json.decode(artistResponse.body)['artists']['items'];
        });
      } else {
        print('Failed Artist Response: ${artistResponse.statusCode}');
        print('Failed Artist Response Body: ${artistResponse.body}');
      }

      final tracksResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=hits&type=track'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      // final tracksResponse = await http.get(
      //   Uri.parse(
      //       'https://api.spotify.com/v1/search?q=genre:thai&type=track&market=TH'), // Memfilter berdasarkan genre Thailand dan pasar Thailand
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );

      // Log status code dan body dari API Tracks
      if (tracksResponse.statusCode == 200) {
        print('Tracks Data: ${tracksResponse.body}');
        setState(() {
          recentlyPlayed = json.decode(tracksResponse.body)['tracks']['items'];
        });
      } else {
        print('Failed Tracks Response: ${tracksResponse.statusCode}');
        print('Failed Tracks Response Body: ${tracksResponse.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List halaman / tab yang dipilih
    List<Widget> _pages = [
      buildHomePage(context),
      SearchPage(), // Navigasi ke SearchPage
      LibraryPage(),
      AccountPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          //  _pages u/ pilih tab
          _pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 6, 0, 0),
        selectedItemColor: const Color.fromARGB(255, 255, 0, 208),
        unselectedItemColor: const Color.fromARGB(255, 117, 117, 117),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget buildHomePage(BuildContext context) {
    List<Widget> _pages = [
      const Text('Search Page', style: TextStyle(color: Colors.white)),
      const Text('Library Page', style: TextStyle(color: Colors.white)),
      AccountPage(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // blur
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // Konten halaman di atas background
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      '4Gem',
                      style: GoogleFonts.shadowsIntoLightTwo(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 0, 208),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                  ),
                  const SizedBox(height: 5),

                  // Discover Playlist
                  const Text(
                    'Discover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    child: playlists.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: playlists.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // load akses token
                                  String accessToken =
                                      await spotifyService.getAccessToken();

                                  //accessToken ada ke -> PlaylistDetailPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistDetailPage(
                                        playlistId: playlists[index]
                                            ['id'], // ID playlist
                                        accessToken: accessToken,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          playlists[index]['images'][0]['url'],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        playlists[index]['name'].length > 15
                                            ? playlists[index]['name']
                                                    .substring(0, 10) +
                                                '...'
                                            : playlists[index]['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 15),

                  // Popular Artist
                  const Text(
                    'Popular Artist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 100,
                    child: popularArtists.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularArtists.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  String accessToken =
                                      await spotifyService.getAccessToken();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArtistDetailPage(
                                        artistId: popularArtists[index]
                                            ['id'], // ID artis
                                        accessToken:
                                            accessToken, // Access token
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: CircleAvatar(
                                          backgroundImage: popularArtists[index]
                                                      ['images']
                                                  .isNotEmpty
                                              ? NetworkImage(
                                                  popularArtists[index]
                                                      ['images'][0]['url'])
                                              : null,
                                          radius: 35,
                                          child: popularArtists[index]['images']
                                                  .isEmpty
                                              ? Icon(Icons.person, size: 35)
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          // Batas char
                                          popularArtists[index]['name'].length >
                                                  12
                                              ? popularArtists[index]['name']
                                                      .substring(0, 12) +
                                                  '...'
                                              : popularArtists[index]['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1, // Batas baris
                                          overflow: TextOverflow
                                              .ellipsis, // text panjang pakai .....
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 15),

                  // Recently Played
                  const Text(
                    'Recently Played',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 1),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recentlyPlayed.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String accessToken =
                              await spotifyService.getAccessToken();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackDetailPage(
                                trackId: recentlyPlayed[index]['id'],
                                accessToken: accessToken,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: recentlyPlayed[index]['album'] != null &&
                                        recentlyPlayed[index]['album']
                                                ['images'] !=
                                            null &&
                                        recentlyPlayed[index]['album']['images']
                                            .isNotEmpty
                                    ? Image.network(
                                        recentlyPlayed[index]['album']['images']
                                            [0]['url'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : const CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      recentlyPlayed[index]['name'].length > 20
                                          ? recentlyPlayed[index]['name']
                                                  .substring(0, 20) +
                                              '...'
                                          : recentlyPlayed[index]['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    recentlyPlayed[index]['artists'][0]['name'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
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
    );
  }
}
