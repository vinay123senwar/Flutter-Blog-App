import 'package:flutter/material.dart';
import 'package:applicationblog/login.dart';
import 'package:applicationblog/homePage.dart';
import 'package:applicationblog/Auth.dart';

class MappingPage extends StatefulWidget
{
  final AuthImplementation auth;

  MappingPage({
   this.auth,
});

  State<StatefulWidget> createState()
  {
    return _MappingPageState();
  }
}

enum AuthStatus
{
  notSignIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage>
{

  AuthStatus authStatus = AuthStatus.notSignIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId)
        {
          setState(() {
            authStatus = firebaseUserId == null ? AuthStatus.notSignIn: AuthStatus.signedIn;
          });
        }
    );

  }

  void _signedIn()
  {
    setState(() {
      authStatus = AuthStatus.signedIn;

    });
  }

  void _signOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignIn;

    });
  }
  @override
  Widget build(BuildContext context)
  {
    switch(authStatus)
    {

      case AuthStatus.notSignIn:
        return new login(
          auth: widget.auth,
          onSignedIn: _signedIn
        );
        break;
      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignedOut: _signOut,
        );
        break;
    }
    return null;
  }
}