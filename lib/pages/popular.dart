import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'description.dart';

class PopularShows extends StatelessWidget {
  PopularShows({Key? key, required this.popularShows}) : super(key: key);

  final List popularShows;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user != null ?
            ModifiedText(text: "Welcome, ${user?.displayName.toString()}", size: 26, color: Colors.white)
          : const ModifiedText(text: "Welcome, Guest", size: 26, color: Colors.white),
          const SizedBox(height: 50),
          const ModifiedText(text: 'Popular TV Shows', size: 26, color: Colors.white70),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularShows.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Description(
                          name: popularShows[index]['name'].toString(),
                          bannerurl:
                          'https://image.tmdb.org/t/p/w500' +
                              popularShows[index]['backdrop_path'].toString(),
                          description: popularShows[index]['overview'].toString(),
                          vote: popularShows[index]['vote_average'].toString(),
                        )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 140,
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' + popularShows[index]['poster_path']
                                  ),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        ModifiedText(text: popularShows[index]['name'] ?? 'Loading', size: 18, color: Colors.white70)
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}