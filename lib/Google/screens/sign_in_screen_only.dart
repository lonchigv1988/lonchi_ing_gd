import 'package:flutter/material.dart';
import '../utils/authentication.dart';
import '../widgets/google_sing_in_button_only.dart';

class SignInScreenOnly extends StatefulWidget {
  @override
  _SignInScreenOnlyState createState() => _SignInScreenOnlyState();
}

class _SignInScreenOnlyState extends State<SignInScreenOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Acceder con Google",
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.grey[400],
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/Lonchi_ing.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Acceder',
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.CheckUser(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButtonOnly();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange[900]!,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
