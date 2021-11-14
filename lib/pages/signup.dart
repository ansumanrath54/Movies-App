import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/pages/homepage.dart';
import 'package:movie_app/pages/login.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final auth = FirebaseAuth.instance;
  late String name;
  late String email;
  late String password;
  late String confirmPassword;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void validate() {
    if(signupFormKey.currentState!.validate()) {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,size: 20,color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Sign up', style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 20,),
                  Text('Create an account', style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),)
                ],
              ),
              Form(
                key: signupFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: validateInput,
                      onChanged: (value){
                        name=value;
                      },
                    ),
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
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Confirm Password"),
                      validator: validateInput,
                      onChanged: (value){
                        confirmPassword=value;
                      },
                      obscureText: true,
                    ),

                  ],
                ),
              ),
              Column(
                children: [
                  Container(
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
                        signUpUser();
                      },
                      color: Colors.lightBlueAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Text('Sign up', style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        child: const Text(' Login',style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      )
                    ],
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () async {
                      signinGoogle();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signinGoogle() async {
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

  Future<void> signUpUser() async {
    if(password.toString() == confirmPassword.toString())
    {
      try{
        await auth.createUserWithEmailAndPassword(
          email: email, password: password,).then((value) async {
            await auth.currentUser!.updateDisplayName(name);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
      catch(e){
        if(password.length < 6) {
          showDialog(context: context, builder: (ctx) => AlertDialog(
            title: const Text("Information"),
            content: const Text("Please enter a valid password"),
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
        }
        else {
          showDialog(context: context, builder: (ctx) => AlertDialog(
            title: const Text("Information"),
            content: const Text("Please input correct email"),
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
        }
      }
    }
    else {
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Alert!"),
        content: const Text("Password did not match"),
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
    }
  }
}
