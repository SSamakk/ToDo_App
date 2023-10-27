import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/components/CustomTextFormField.dart';
import 'package:todo/auth/register/RegisterScreen.dart';
import 'package:todo/firebaseUtils.dart';

import '../../dialogUtils.dart';
import '../../home/homescreen.dart';
import '../../providers/authProvider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'shimaa@route.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/background.png',
            height: MediaQuery.of(context).size.height*0.66,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.3,),
                  CustomTextFormField(label: 'Email Address',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validate: (text) {
                      if(text == null || text.trim().isEmpty) {
                        return 'Please enter Email Address';
                      }
                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if(!emailValid) {
                        return "Please enter a valid Email Address";
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(label: 'Password',
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.number,
                    validate: (text) {
                      if(text == null || text.trim().isEmpty) {
                        return 'Please enter Password';
                      }
                      if(text.length < 6) {
                        return "Password should be at leaser 6 characters";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        Login();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8)
                      ),
                      child: Text("Login",
                        style: Theme.of(context).textTheme.titleMedium,),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      // navigate
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                    child: const Text('Don\'t have an account? Register',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Login() async {
    // todo: show Loading
    DialogUtils.showLoading(context, 'Loading...');

    if(formKey.currentState?.validate() == true){
      // register
      try {
        final credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // todo: get user
        var user = await FireBaseUtils.readUserFromFirestore(
            credential.user?.uid ?? '');
        if(user == null){
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(user);

        // todo: hide Loading
        DialogUtils.hideDialog(context);
        // todo: show Register Success
        DialogUtils.showMessage(context,
            'Login Complete',
            title: 'Sucess',
            posActionName: 'Ok',
            posAction: (){
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            }
        );
      }

      on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // todo: hide Loading
          DialogUtils.hideDialog(context);
          // todo: show Register Success
          DialogUtils.showMessage(context,
              'No user found for that email',
              title: 'Error',
              posActionName: 'Ok');
        }
        else if (e.code == 'wrong-password') {
          // todo: hide Loading
          DialogUtils.hideDialog(context);
          // todo: show Register Success
          DialogUtils.showMessage(context,
              'Wrong password provided for that user',
              title: 'Error',
              posActionName: 'Ok');
        }
      }
      catch (e) {
        // todo: hide Loading
        DialogUtils.hideDialog(context);
        // todo: show Error msg
        DialogUtils.showMessage(context,
            e.toString(),
            title: 'Error',
            posActionName: 'Ok');
      }
    }
  }
}

