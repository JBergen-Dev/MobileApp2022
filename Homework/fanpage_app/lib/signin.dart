import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignIn();

}
class _SignIn extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override 
  Widget build(BuildContext context) {
    return  Scaffold (body: _loading ? const LoadingPage() :Center(
      child: Form(
        key: _formKey,
        child: Column(
        children: [
          TextFormField( controller: _email,
            validator: (String? text){
              if(text == null || text.isEmpty){
              return "Must Enter Email";
              }else if(!text.contains('@')){
                return "email is formatted incorrectly";
              }
              return null;
            }),
          TextFormField( controller: _password,
            validator: (String? text){
              if(text == null || text.length < 6){
              return "Password must be at least 6 characters";
              }
              return null;
            }),
          TextFormField( controller: _password,
            validator: (String? text){
              if(text == null || text.length < 6){
              return "Password must be at least 6 characters";
              } else if (text != _password.text){
                return "Your passwords do not match";
              }
              return null;
            }),
          ElevatedButton(onPressed: (){
            setState(() {
            _loading = true;
            logIn(context);
            });
            },
           child: const Text("Log In"),),
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegistrationPage()));
          },
           child: const Text("Register"),), 
          ElevatedButton(onPressed: (){},
           child: const Text("Sign in with Facebook"),), 
          ElevatedButton(onPressed: (){},
           child: const Text("Forgot Password"),),   
        ],
      ),
    ),
    )
  );
    }

  void logIn(BuildContext context) async{
    if(_formKey.currentState!.validate()){
      try{
        await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
      } on FirebaseAuthException catch(e){
        if (e.code == "wrong-password" || e.code == "no_email"){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect email/password")));
        }
      } catch (e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }  
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
  
}
