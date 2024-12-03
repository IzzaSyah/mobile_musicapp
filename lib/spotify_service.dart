import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyService {
  final String clientId = '4e034b797a6444c7bfd1f2e175711f1b'; // Client ID 
  final String clientSecret = '78c450942c58466d96d6025b769e9912'; // Client Secret 

  // Fungsi untuk mendapatkan Access Token
  Future<String> getAccessToken() async {
    final String credentials = '$clientId:$clientSecret';
    final String encodedCredentials = base64Encode(utf8.encode(credentials));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $encodedCredentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }
}
