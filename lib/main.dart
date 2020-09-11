import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/tambahdata.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: deprecated_member_use
  FirebaseUser _user;

  // ignore: deprecated_member_use
  Future<FirebaseUser> _loginGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    // ignore: deprecated_member_use
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, 
      accessToken: googleAuth.accessToken);
    
    final user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }

  @override
  initState(){
    super.initState();
    FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_user == null ? "Login user" : "Anda Login sebagai ${_user.displayName}"),
            SizedBox(height: 10,),

            OutlineButton(
              onPressed: () async {
                if(_user == null){
                  final user = await _loginGoogle();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (contex) => TambahData(user: user,))
                  );
                }else{
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (contex) => TambahData(user: _user,))
                  );
                }
              },
              child: Text(
                _user == null
                ? "Login"
                : "Tambah Data"
              ),
            )
          ],
        ),
      ),
    );
  }
}

