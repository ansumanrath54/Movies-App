import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';

class Description extends StatelessWidget {
  const Description({Key? key,
    required this.name,
    required this.bannerurl,
    required this.description,
    required this.vote}) : super(key: key);

  final String? name,bannerurl,description,vote;

  Widget getBanner() {
    if(bannerurl == "https://image.tmdb.org/t/p/w500null") {
      return Image.asset('assets/no-image.jpg', fit: BoxFit.cover,);
    }
    else {
      return Image.network(bannerurl!, fit: BoxFit.cover,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const ModifiedText(text: 'Movies App 🤩', color: Colors.white, size: 20),
      ),
      body: ListView(children: [
        SizedBox(
            height: 250,
            child: Stack(children: [
              Positioned(
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: getBanner(),
                ),
              ),
            ])),
        const SizedBox(height: 15),
        Container(
            padding: const EdgeInsets.all(10),
            child:
            Column(
              children: [
                ModifiedText(text: name == '' ? 'Not Available' : name.toString(), size: 24, color: Colors.white70),
                const SizedBox(height: 5),
                ModifiedText(text: '⭐ Average Rating - ${vote == '0' ? 'Not Available' : vote.toString()} ', color: Colors.white70, size: 15,),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    ModifiedText(text: 'Description:-', size: 28, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 5),
                ModifiedText(text: description == '' ? 'Not Available' : description.toString(), size: 18, color: Colors.white70)
              ],
            )),
      ]),
    );
  }
}

