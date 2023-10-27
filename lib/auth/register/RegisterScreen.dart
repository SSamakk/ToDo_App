import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/components/CustomTextFormField.dart';
import 'package:todo/auth/login/LoginScreen.dart';
import 'package:todo/firebaseUtils.dart';
import 'package:todo/home/homescreen.dart';
import 'package:todo/model/myUser.dart';

import '../../dialogUtils.dart';
import '../../providers/authProvider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'Shimaa');

  var emailController = TextEditingController(text: 'shimaa@route.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmPasswordController = TextEditingController(text: '123456');

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
                  CustomTextFormField(label: 'Username',
                    controller: nameController,
                    validate: (text) {
                      if(text == null || text.trim().isEmpty) {
                        return 'Please enter Username';
                      } else {
                        return null;
                      }
                    },
                  ),
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
                          return "Password should be at leasr 6 characters";
                        }
                        return null;
                      },
                  ),
                  CustomTextFormField(label: 'Confirm Password',
                      obscureText: true,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.number,
                      validate: (text) {
                        if(text == null || text.trim().isEmpty) {
                          return 'Please confirm Password';
                        }
                        if(text != passwordController.text) {
                          return "Please enter same Password";
                        }
                        return null;
                      },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: (){
                          Register();
                        },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8)
                      ),
                        child: Text("Register",
                          style: Theme.of(context).textTheme.titleMedium,),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // navigate
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                        },
                        child: const Text('Already have an account? login',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                          ),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Register() async {
    // todo: show Loading
    DialogUtils.showLoading(context, 'Loading...');

    if(formKey.currentState?.validate() == true){
      // register
      try {
        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // todo: add user
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text,
        );
        await FireBaseUtils.addUserToFirestore(myUser);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);

        // todo: hide Loading
        DialogUtils.hideDialog(context);
        // todo: show Register Success
        DialogUtils.showMessage(context,
            'Register Complete',
            title: 'Sucess',
            posActionName: 'Ok',
            posAction: (){
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            }
        );
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo: hide Loading
          DialogUtils.hideDialog(context);
          // todo: show Register Success
          DialogUtils.showMessage(context,
              'The password provided is too weak',
              title: 'Error',
              posActionName: 'Ok');
        }
        else if (e.code == 'email-already-in-use') {
          // todo: hide Loading
          DialogUtils.hideDialog(context);
          // todo: show Register Success
          DialogUtils.showMessage(context,
              'The account already exists for that email',
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

