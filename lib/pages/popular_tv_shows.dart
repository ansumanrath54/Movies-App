import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'description.dart';

class PopularShows extends StatelessWidget {
  const PopularShows({Key? key, required this.popularShows}) : super(key: key);

  final List popularShows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(text: 'Popular TV Shows', size: 26, color: Colors.white70),
          const SizedBox(height: 10),
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