import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:college_minor_project_frontend/constants/Utils.dart';
import 'package:college_minor_project_frontend/helpers/FirebaseAuthHelper.dart';
import 'package:college_minor_project_frontend/helpers/PrefsHelper.dart';
import 'package:college_minor_project_frontend/screens/HomeScreen.dart';
import 'package:college_minor_project_frontend/widgets/TextFieldCustom.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordNotVisible = true;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.purple_bg,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: isLoading ? CircularProgressIndicator(
              color: AppStyle.red,
            ) : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Utils.width(context) / 20,
                  vertical: Utils.height(context) / 30,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppStyle.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: Utils.width(context) / 15,
                    ),
                    Card(
                      color: AppStyle.purple_light,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Utils.width(
                            context) / 50,),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Utils.width(context) / 20,
                          vertical: Utils.height(context) / 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TextFieldCustom(
                            //   controller: nameController,
                            //   hintText: 'Enter name',
                            //   keyboardType: TextInputType.text,
                            //   icon: Icons.person,
                            //   validator: (value) {
                            //     if (value != null) {
                            //       if (value.isEmpty) {
                            //         return 'Email can\'t be empty';
                            //       }
                            //     }
                            //   },
                            // ),
                            // SizedBox(
                            //   height: Utils.width(context) / 30,
                            // ),
                            TextFieldCustom(
                              controller: emailController,
                              hintText: 'Enter email',
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Email can\'t be empty';
                                  } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return 'Please enter correct email';
                                  }
                                }
                              },
                            ),
                            // SizedBox(
                            //   height: Utils.width(context) / 30,
                            // ),
                            // TextFieldCustom(
                            //   controller: phoneNumberController,
                            //   hintText: 'Enter phone number',
                            //   keyboardType: TextInputType.phone,
                            //   icon: Icons.phone,
                            //   validator: (value) {
                            //     if (value != null) {
                            //       if (value.isEmpty) {
                            //         return 'Password can\'t be empty';
                            //       } else if (value.length < 10) {
                            //         return 'Phone number length must be 10';
                            //       }
                            //     }
                            //   },
                            // ),
                            SizedBox(
                              height: Utils.width(context) / 30,
                            ),
                            TextFieldCustom(
                              controller: passwordController,
                              hintText: 'Enter password',
                              keyboardType: TextInputType.visiblePassword,
                              icon: Icons.lock,
                              obscureText: isPasswordNotVisible,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordNotVisible =
                                    !isPasswordNotVisible;
                                  });
                                },
                                icon: FaIcon(
                                  isPasswordNotVisible ? FontAwesomeIcons
                                      .eyeSlash : FontAwesomeIcons.eye,
                                  color: AppStyle.white,),
                              ),
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Password can\'t be empty';
                                  } else if (value.length < 6) {
                                    return 'Password length must be 6';
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: Utils.width(context) / 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirebaseAuthHelper().registerUser(email: emailController.text.toString(), password: passwordController.text.toString()).then((value) {
                                      PrefsHelper().saveEmail(emailController.text.toString());
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
                                      // setState(() {
                                      //   isLoading = false;
                                      // });
                                    }).catchError((onError) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Utils.showToast(message: 'Some error occurred, please try again later');
                                    });
                                  }
                                },
                                child: Text('SIGN UP'),
                                style: ElevatedButton.styleFrom(
                                  primary: AppStyle.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
