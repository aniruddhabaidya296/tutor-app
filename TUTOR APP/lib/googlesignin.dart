// @dart=2.12
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:student/createprofilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:student/homepage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

Uuid uid = Uuid();

class googleSignIn extends StatefulWidget {
  const googleSignIn({Key? key}) : super(key: key);

  @override
  googleSignInState createState() => googleSignInState();

  // void handleSignIn() {}
  void handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void handleSignOut() => _googleSignIn.disconnect();
}

DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
final FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    // 'https://www.googleapis.com/auth/cloud-platform',
  ],
);

class googleSignInState extends State<googleSignIn> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  void handleSignOut() => _googleSignIn.disconnect();

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);

    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  void handleSignIn() async {
    debugPrint("google sign in object created");
    print("$_currentUser");
    try {
      await _googleSignIn.signIn();
      print(
          "_currentUser: $_currentUser--------------------------------------------------------------");
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      String credentialText = credential.toString();
      print(
          "credentials: $credentialText=================================================");
      UserCredential authResult = await auth.signInWithCredential(credential);
      print(
          "authResult: $authResult================================================");
      User? firebaseUser = authResult.user;
      dbRef.child(authResult.user!.uid).set({
        "user email": firebaseUser!.email,
        // "credential": credentialText,
        "name": firebaseUser.displayName,
        "uid": authResult.user!.uid
      });
    } catch (error) {
      print(error);
      print(
          "***********************************************************************");
      print(
          "$_currentUser--------------------------------------------------------------");
      print(
          "***********************************************************************");
    }
    // print(
    //     "$_currentUser--------------------------------------------------------------");
    // print(
    //     "$user***********************************************************************");
  }

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      debugPrint(
          "$_currentUser--------------------------------------------------------------");
      debugPrint(
          "$user***********************************************************************");
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text("Signed in successfully."),
          Text(_contactText),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: handleSignOut,
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: () {
                handleSignIn();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomePage()),
                //     ModalRoute.withName('/home'));
              }),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
