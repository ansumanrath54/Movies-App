import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'description.dart';

class PopularMovies extends StatelessWidget {
  const PopularMovies({Key? key, required this.popularMovies}) : super(key: key);

  final List popularMovies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(text: 'Popular Movies', size: 26, color: Colors.white70),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Description(
                          name: popularMovies[index]['title'].toString(),
                          bannerurl:
                          'https://image.tmdb.org/t/p/w500' +
                              popularMovies[index]['backdrop_path'].toString(),
                          description: popularMovies[index]['overview'].toString(),
                          vote: popularMovies[index]['vote_average'].toString(),
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
                                      'https://image.tmdb.org/t/p/w500' + popularMovies[index]['poster_path']
                                  ),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        ModifiedText(text: popularMovies[index]['title'] ?? 'Loading', size: 18, color: Colors.white70)
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
