import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final Future<Post> post;

  MyApp({Key key, this.post}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = "Login Demo";
    return MaterialApp(title: appTitle,
        debugShowCheckedModeBanner: false,
        home: Scaffold(appBar: AppBar(title: Text(appTitle),
        ),
            body: LoginForm())
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myPassword = TextEditingController();


  @override
  void dispose() {
    myController.dispose();
    myPassword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter User Name',
                    //  border: InputBorder.none
                  ),
                  controller: myController,
                ),

                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter password'
                  ),
                  controller: myPassword,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () async
                    {
                      if (_formKey.currentState.validate()) {
                        var card = "card=" + myController.text;
                        var password = "password=" + myPassword.text;
                        Post p = await createPost(
                            "http://nhsdubai.fortiddns.com:603//api/Users/LoginMember?" +
                                card + "&" + password);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              new UserModel.fromJson(p.Data).PayerMemberName),
                          action: SnackBarAction(label: "Undo",
                              onPressed: () {
                                return showDialog(
                                    context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Text("Undone success"),
                                  );
                                });
                              }),));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(userModel: new UserModel.fromJson(p.Data),)
                            ));
                      }
                    },
                    child: Text('Login'),
                  ),
                )
              ],
            ),
          )
      );
  }
}


class Post {

  final int StatusCode;
  final String Message;
  final Object Data;

  Post({this.StatusCode, this.Message, this.Data});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      StatusCode: json['StatusCode'],
      Message: json['Message'],
      Data: json['Data'],
    );
  }
}

class UserModel {

  final int UserId;
  final String MemberCard;
  final String AccessToken;
  final String PayerMemberName;
  final String PictureUrl;
  final String PayerMemberMobileNumber;


  UserModel(
      {this.UserId, this.MemberCard, this.AccessToken, this.PayerMemberName, this.PictureUrl, this.PayerMemberMobileNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      UserId: json['UserId'],
      MemberCard: json['MemberCard'],
      AccessToken: json['AccessToken'],
      PayerMemberName: json['PayerMemberName'],
      PictureUrl: json['PictureUrl'],
      PayerMemberMobileNumber: json['PayerMemberMobileNumber'],
    );
  }
}


Future<Post> createPost(String url) async {
  return http.post(url).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}


class DetailPage extends StatelessWidget {
  final UserModel userModel;

  const DetailPage({Key key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details"),),
      body: Center(
           child: Column(
               children: <Widget>[
                 Text("User Id: "),
                 Text("Member Card: "),
                 Text("Access Token: "),
                 Text("Name: "),
                 Text("Mobile: "),
                 RaisedButton( onPressed: (){
                   Scaffold.of(context).showSnackBar(SnackBar(content: Text("Confirmed")));
                 },
                   child: Text("Confirm"),
                 )
               ],
             )

            )
        );
  }

}



