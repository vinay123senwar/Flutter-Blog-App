import 'package:applicationblog/DialogBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
class login extends StatefulWidget {

  login({
    this.auth,
    this.onSignedIn,
});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  _loginState createState() => _loginState();

}

enum FormType
{
  login, register
}
class _loginState extends State<login>
{

  DialogBox dialogBox =new DialogBox();
  final formKey =new GlobalKey<FormState>();
  FormType _formType =FormType.login;
  String _email ="";
  String _password ="";
  bool validateAndSave()
  {
    final form= formKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }

  void validateAndSubmit() async
  {
    if(validateAndSave())
      {
        try {
          if (_formType == FormType.login) {
            String userId = await widget.auth.SignIn(_email, _password);
            //dialogBox.information(context, "SignIn", "Please wait while we Signing in");
            print("LOGIN USER ID =" + userId);
          }
          else {
            String userId = await widget.auth.SignUp(_email, _password);
            //dialogBox.information(context, "SignUp", "Please wait while we create account");
            print("REGISTER USER ID =" + userId);
          }

          widget.onSignedIn();
        }catch(e)
        {
          dialogBox.information(context, "ERROR =", e.toString());
          print(e.toString());
        }
      }
  }
  void moveToRegister()
  {
    formKey.currentState.reset();
    setState(() {
      _formType= FormType.register;
    });
  }

  void moveToLogin()
  {
    formKey.currentState.reset();
    setState(() {
      _formType= FormType.login;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter blog app"),
      ),
      body: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + Buttons(),

            )
        ),
      ),
    );
  }


  List<Widget> createInputs()
  {
    return
      [
        SizedBox(height: 10.0,),
        logo(),
        SizedBox(height: 10.0,),
        new TextFormField(
          decoration: new InputDecoration(labelText: "Email..."),
          validator: (value)
          {
            return value.isEmpty ? 'Email Is Required': null;
          },

          onSaved: (value)
          {
            return _email= value;
          },

        ),

        SizedBox(height: 10.0,),
        new TextFormField(
          decoration: new InputDecoration(labelText: "Password..."),
          obscureText: true,
          validator: (value)
          {
            return value.isEmpty ? 'Password Is Required': null;
          },

          onSaved: (value)
          {
            return _password= value;
          },
        ),

        SizedBox(height: 10.0,),
      ];
  }

  Widget logo()
  {
    return new Hero(tag: 'hero', child: new CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 80.0,
      child: Image.asset('images/applogo.png'),
    ));
  }

  List<Widget> Buttons()
  {
    if(_formType == FormType.login)
    {
      return
        [
          new RaisedButton
            (
            onPressed: validateAndSubmit,
            child: new Text("Login",style: new TextStyle(fontSize: 10.0)),
            textColor: Colors.white,
            color: Colors.blue,
          ),

          new FlatButton
            (
            onPressed: moveToRegister,
            child: new Text("Not Have An Account?Create An Account",style: new TextStyle(fontSize: 10.0)),
            textColor: Colors.blue,
          ),
        ];
    }
    else
    {
      return
        [
          new RaisedButton
            (
            onPressed: validateAndSubmit,
            child: new Text("Create Account",style: new TextStyle(fontSize: 10.0)),
            textColor: Colors.white,
            color: Colors.blue,
          ),

          new FlatButton
            (
            onPressed: moveToLogin,
            child: new Text("Already have an account",style: new TextStyle(fontSize: 10.0)),
            textColor: Colors.blue,
          ),
        ];
    }
  }
}
