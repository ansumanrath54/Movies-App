import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/pages/login.dart';
import 'package:movie_app/pages/popular_movies.dart';
import 'package:movie_app/pages/popular_tv_shows.dart';
import 'package:movie_app/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final googleSignIn = GoogleSignIn();
  User? user = FirebaseAuth.instance.currentUser;
  DateTime dateTime = DateTime.now();
  List popularTvShows = [];
  List popularMovies = [];
  final String apikey = 'b2cf1684b45e4a6c727938b37b14510f';
  final accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMmNmMTY4NGI0NWU0YTZjNzI3OTM4YjM3YjE0NTEwZiIsInN1YiI6IjYxOGNhNDFlY2I2ZGI1MDAyYzNiYjAxMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.bt1LNb7JCSn5x-AJ1lIvQIVXuvFdDXC4IZwWS8gzTnM';

  void loadMovies() async {
    final tmdbWithCustomLogs = TMDB(
        ApiKeys(apikey, accessToken),
        logConfig: ConfigLogger(
            showLogs: true,
            showErrorLogs: true
        )
    );
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPouplar();
    Map movieResult = await tmdbWithCustomLogs.v3.movies.getPouplar();
    setState(() {
      popularTvShows = tvResult['results'];
      popularMovies = movieResult['results'];
    });
  }

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(dateTime);
          final isExitWarning = difference >= const Duration(seconds: 2);
          dateTime = DateTime.now();
          if(isExitWarning) {
            const message = 'Press back again to exit';
            Fluttertoast.showToast(msg: message);
            return false;
          }
          else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
          backgroundColor: Colors.black12,
          automaticallyImplyLeading: false,
          title: const ModifiedText(text: 'Movies App 🤩', color: Colors.white, size: 20),
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.blueGrey,
                      title: const ModifiedText(text: "Logout", color: Colors.white, size: 23),
                      content: const ModifiedText(text: "Are you sure you want to logout?", color: Colors.white, size: 18),
                      actions: [
                        FlatButton(
                          child: const ModifiedText(text: "NO", color: Colors.white, size: 16),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const ModifiedText(text: "YES", color: Colors.white, size: 16),
                          onPressed: () async {
                            try {
                              await googleSignIn.disconnect();
                            } catch(e) {
                              print(e);
                            }
                            await FirebaseAuth.instance.signOut();
                            const snackBar = SnackBar(
                              content: Text("You're logged out!"),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                        )
                      ],
                    ));
              },
              child: const Icon(Icons.power_settings_new, color: Colors.white,),
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: user != null ?
                ModifiedText(text: "Welcome, ${user?.displayName.toString()}", size: 26, color: Colors.white)
                    : const ModifiedText(text: "Welcome, Guest", size: 26, color: Colors.white)
            ),
            PopularMovies(popularMovies: popularMovies),
            PopularShows(popularShows: popularTvShows)
          ],
        ),
    ),
      );
  }
}
