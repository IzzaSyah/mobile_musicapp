import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  final String podcastTitle;

  PlayerPage({required this.podcastTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade900,
        title: Text(podcastTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://via.placeholder.com/150',
              height: 150,
            ),
            SizedBox(height: 30),
            Text(
              podcastTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Turning Connection into Opportunities'),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 48,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 50),
            Slider(
              value: 0.3,
              onChanged: (newValue) {},
            ),
          ],
        ),
      ),
    );
  }
}
