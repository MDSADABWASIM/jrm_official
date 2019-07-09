import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn();
  Future<String> currentUserfirebase();
  Future<void> signOut();
}

///here we do our auth stuffs and
///notify root page what to show now.
class Auth implements BaseAuth {
  final BuildContext context;
  Auth(this.context);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  _handleSignIn() async {
    try {
      var signIn = await googleSignIn.signIn();
      return signIn;
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount account = await _handleSignIn();
    GoogleSignInAuthentication _gsa = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _gsa.accessToken,
      idToken: _gsa.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);

    return user;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<String> currentUserfirebase() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }
}
