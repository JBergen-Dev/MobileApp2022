import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Register();

}
class _Register extends State<RegistrationPage> {
  final _display = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override 
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar: AppBar(title: const Text("Registration")),
      body: _loading ? const LoadingPage() :Center(
      child: Form(
        key: _formKey,
        child: Column(
        children: [
          TextFormField( controller: _display,
            validator: (String? text){
              if(text == null || text.isEmpty){
              return "Must enter a display name";
              }else if(DatabaseService.usernames.contains(text.toLowerCase())){
                return "Display name already in use";
              }
              return null;
            }),
          TextFormField( controller: _email,
            validator: (String? text){
              if(text == null || text.isEmpty){
              return "Must Enter Email";
              }else if(!text.contains('@')){
                return "your email is formatted incorrectly";
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
          TextFormField(
            validator: (String? text){
              if(text == null || text.length < 6){
              return "Password must be at least 6 characters";
              } else if (text != _password.text){
                return "Your passwords do not match";
              }
              return null;
            }),  
          ElevatedButton(onPressed: ()  {
            setState(() {
              _loading = true;
            register(context);
            });
            },
           child: const Text("Register"),),
          
        ],
      ),
    ),
    )
  );
    }

  void register(BuildContext context) async{
    if(_formKey.currentState!.validate()){
      try{
        await _auth.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
      } on FirebaseAuthException catch(e){
        if (e.code == "wrong-password" || e.code == "no_email"){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect email/password")));
        }
      } catch (e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      try {
        if(_auth.currentUser != null){
         await _db.collection("users").doc(_auth.currentUser!.uid).set(
           {
             "display_name": _display.text,
             "role": "USER", 
             "email": _email.text
           }
         );
         
        }
      } on FirebaseException catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message?? "Unknown Error") ));
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
