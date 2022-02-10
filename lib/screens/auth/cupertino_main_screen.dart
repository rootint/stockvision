import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

// username
// email
// password
// confirm password
// link subscription to username (could be used on any device????)
// definitely not!!!


class CupertinoAuthScreen extends StatefulWidget {
  const CupertinoAuthScreen({Key? key}) : super(key: key);

  @override
  _CupertinoAuthScreenState createState() => _CupertinoAuthScreenState();
}

class _CupertinoAuthScreenState extends State<CupertinoAuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLoginMode,
  ) async {
    UserCredential userCredentials;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLoginMode) {
        userCredentials = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance.ref().child('user_images').child(userCredentials.user!.uid + 'jpg');
        if (image != null) {
          // add a placeholder image if not selected or what
          await ref.putFile(image);
        }
      }
    } on FirebaseAuthException catch (error) {
      print('FIREBASE: $error');
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return CupertinoPageScaffold(
    //   child: CupertinoAuthScreen(_submitAuthForm, _isLoading),
    // );
    return Container();
  }
}
