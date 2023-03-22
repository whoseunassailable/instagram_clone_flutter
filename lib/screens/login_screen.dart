import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/constants/strings.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/sign_up_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/custom_button.dart';
import 'package:instagram/widgets/text_field_input.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Initialisation of variables
  Logger logger = Logger(printer: PrettyPrinter(colors: true));
  bool isLoading = false;

  // TextEditing Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Initialisation of classes
  final AuthMethods authMethods = AuthMethods();

  final _formKey = GlobalKey<FormState>();

  bool textHidden = true;
  late Widget trailingImage = SvgPicture.asset(
    'assets/icons/hidden_eye.svg',
    height: 8,
    width: 10,
    color: Colors.white70,
  );
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  loginUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      logger.d('The value for email is ${_emailController.text}');
      logger.d('The value for password is ${_passwordController.text}');
    }
    var authenticateUser = await authMethods.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );
  }

  showCircularProgressIndicator(bool isLoading) {
    if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.lightBlueAccent,
        ),
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Instagram logo
                  SvgPicture.asset(
                    'assets/icons/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        // Phone number, email or email address
                        Center(
                          child: TextFieldWidget(
                            hintText: emailHint,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            errorTextMessage: pleaseEnterYourEmail,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Password
                        Center(
                          child: TextFieldWidget(
                            hintText: password,
                            obscureText: textHidden,
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            errorTextMessage: passwordCannotBeEmpty,
                            trailingImage: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                child: trailingImage,
                                onTap: () {
                                  count++;
                                  logger.d('The count is $count');
                                  if (count % 2 == 0) {
                                    setState(
                                      () {
                                        textHidden = false;
                                        trailingImage = SvgPicture.asset(
                                          'assets/icons/hidden_eye.svg',
                                          height: 8,
                                          width: 10,
                                          color: Colors.white70,
                                        );
                                      },
                                    );
                                  } else {
                                    setState(
                                      () {
                                        textHidden = true;
                                        trailingImage = SvgPicture.asset(
                                          'assets/icons/visible_eye.svg',
                                          height: 8,
                                          width: 10,
                                          color: Colors.white70,
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              forgotPassword,
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        // Login Button
                        CustomButton(
                          text: login,
                          onPressed: loginUser,
                          colorForButton: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // divider
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 0.8,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(or.toUpperCase()),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom stack
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Divider(
                      thickness: 0.8,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Don't have an account
                        const Text(
                          dontHaveAnAccount,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        // sign Up
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            signUp,
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
