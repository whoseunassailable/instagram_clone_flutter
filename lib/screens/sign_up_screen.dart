import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/utils/utils.dart';
import '../constants/strings.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Initialisation of variables
  int count = 0;
  Uint8List? galleryImage;
  bool isLoading = false;

  // TextEditing Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Global Key for the form
  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();

  bool textHidden = true;
  late Widget trailingImage = SvgPicture.asset(
    'assets/icons/hidden_eye.svg',
    height: 8,
    width: 10,
    color: Colors.white70,
  );

  signUpUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
    }
    try {
      setState(() {
        isLoading = true;
      });

      var res = await authMethods.signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          file: galleryImage,
          context: context);
      setState(() {
        isLoading = false;
      });
      print('The details for registered user are : $res');
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Function to select an image
  void selectImage() async {
    Uint8List _image = await pickImage(ImageSource.gallery);
    setState(() {
      galleryImage = _image;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                // Circle Avatar
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 64,
                                      backgroundImage: galleryImage == null
                                          ? const AssetImage(
                                              'assets/images/default_icon.png')
                                          : MemoryImage(galleryImage!)
                                              as ImageProvider,
                                    ),
                                    Positioned(
                                      bottom: -15,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          selectImage();
                                        },
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.purple.shade300,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      // User name text field
                                      Center(
                                        child: TextFieldWidget(
                                          hintText: username,
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          controller: _usernameController,
                                          errorTextMessage:
                                              usernameCannotBeEmpty,
                                          // onChanged: (value) {
                                          //   setState(() {
                                          //     _username = value;
                                          //   });
                                          // },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Email Address text field
                                      Center(
                                        child: TextFieldWidget(
                                          hintText: emailHint,
                                          obscureText: false,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: _emailController,
                                          errorTextMessage:
                                              pleaseEnterYourEmail,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Bio text field
                                      Center(
                                        child: TextFieldWidget(
                                          hintText: bio,
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          controller: _bioController,
                                          errorTextMessage: bioCannotBeEmpty,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Password Text Field
                                      Center(
                                        child: TextFieldWidget(
                                          hintText: password,
                                          obscureText: textHidden,
                                          keyboardType: TextInputType.text,
                                          controller: _passwordController,
                                          errorTextMessage:
                                              passwordCannotBeEmpty,
                                          trailingImage: Container(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: GestureDetector(
                                              child: trailingImage,
                                              onTap: () {
                                                count++;
                                                print('The count is $count');
                                                if (count % 2 == 0) {
                                                  setState(
                                                    () {
                                                      textHidden = false;
                                                      trailingImage =
                                                          SvgPicture.asset(
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
                                                      trailingImage =
                                                          SvgPicture.asset(
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
                                    ],
                                  ),
                                ),

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
                                CustomButton(
                                  text: signUp,
                                  onPressed: signUpUser,
                                  colorForButton: Colors.lightBlueAccent,
                                ),
                                const SizedBox(height: 25),
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
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const Divider(
                            thickness: 0.8,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                alreadyHaveAnAccount,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  login,
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
