import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/pages/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  DateTime dateTime = DateTime.now();
  final auth=FirebaseAuth.instance;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late String email;
  late String password;

  void validate() {
    if(loginFormKey.currentState!.validate()) {
      print('Validated');
    }
    else {
      print('Not validated');
    }
  }

  String? validateInput(value) {
    if(value!.isEmpty) {
      return "Required";
    } else {
      return null;
    }
  }


  @override

  Widget build(BuildContext context) {
    return WillPopScope(
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child:
            Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('Login', style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 20,),
                            Text('Login to your account', style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700]
                            ),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(labelText: "Email"),
                                validator: validateInput,
                                onChanged: (value){
                                  email=value;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: "Password"),
                                validator: validateInput,
                                onChanged: (value){
                                  password=value;
                                },
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: const EdgeInsets.only(top: 3,left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                validate();
                                loginUser();
                              },
                              color: Colors.lightBlueAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: const Text('Login', style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                                  },
                                  child: const Text(' Sign Up',style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                  ),),
                                )
                              ],
                            ),
                            SignInButton(
                              Buttons.Google,
                              text: "Sign in with Google",
                              onPressed: () async {
                                loginGoogle();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.7,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/background.jpg'),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async{
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((FirebaseUser) async{
      const snackBar = SnackBar(
        content: Text("You're successfully logged in!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    })
        .catchError((e){
      print(e);
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Alert!"),
        content: const Text("Invalid Email or Password"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
      );
    });
  }

  Future<void> loginGoogle() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    const snackBar = SnackBar(
      content: Text("You're signed in successfully!"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }
}