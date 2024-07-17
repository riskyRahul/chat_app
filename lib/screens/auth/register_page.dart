import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:chat_app/auth/email_auth.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:chat_app/utils/validators_util.dart';
import 'package:chat_app/widget/button.dart';
import 'package:chat_app/widget/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;
  bool isChecked = false;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController conffPasswordTextEditingController =
      TextEditingController();
  final EmailAuth _emailAuth = EmailAuth();
  UserModel? userModel;
  final DBServices _dbServices = DBServices();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? snackBarText;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final GoogleAuth _googleAuth = GoogleAuth();

  bool isLoading = false;
  bool isGoogleLoading = false;

  String phoneNumber = '';
  String contryCode = '';

  @override
  void initState() {
    _setCountryCode();
    super.initState();
  }

  void _setCountryCode() {
    String? locale = Intl.getCurrentLocale();
    contryCode = locale.split('_').last;
    print(contryCode);
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordTextEditingController.text.trim()) {
      return AppStrings.pwdNotMatchErrorMessageText;
    } else {
      return null;
    }
  }

  // Future<String?> _validatePhoneNumber(String? value) async {
  //   var a = await _db
  //       .collection("users")
  //       .where('phoneNumber', isEqualTo: value)
  //       .get();
  //       print("!!!!!!!!!!!!!!!!!!!!!!");
  //       print(a.size );
  //   if (value != null) {
  //     return AppStrings.phoneReqErrorMessageText;
  //   } else if (a.size == 1) {
  //     return AppStrings.phoneReqErrorMessageText;
  //   } else {
  //     return null;
  //   }
  // }

  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
      content: Text(
        val,
        style: getSemiBoldStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20,
          left: 20),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 64, right: 16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: Container(
                          margin: const EdgeInsets.only(top: AppMargin.m40),
                          height: AppSize.s45,
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s14,
                        width: double.infinity,
                      ),
                      FadeInRight(
                          child: Text(
                        'Sign Up Now!',
                        style: getSemiBoldStyle(
                            color: ColorManager.textColor, fontSize: 20),
                      )),
                      const SizedBox(
                        height: AppSize.s8,
                        width: double.infinity,
                      ),
                      FadeInRight(
                          child: Text(
                        'Login to see our new collections!',
                        style: getRegularStyle(
                            color: ColorManager.hintTextColor, fontSize: 14),
                      )),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      FadeInRight(
                        child: EditTextFormField.sempleTextField(
                            labelText: 'Name *',
                            textEditingController: nameTextEditingController),
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      FadeInRight(
                        child: EditTextFormField.sempleTextField(
                            labelText: 'Email *',
                            textEditingController: emailTextEditingController),
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      // FadeInRight(
                      //   child: EditTextFormField.sempleTextField(
                      //       labelText: 'Phone *',
                      //       textEditingController: emailTextEditingController),
                      // ),
                      FadeInRight(
                        child: IntlPhoneField(
                          cursorColor: ColorManager.primary,
                          controller: phoneTextEditingController,
                          showDropdownIcon: false,
                          decoration: InputDecoration(
                              hintText: '',
                              // labelText: 'Phone *',
                              hintStyle: getRegularStyle(
                                  color: ColorManager.textColor,
                                  fontSize: 14,
                                  isWithShadow: false),
                              border: customBorder(),
                              errorBorder: customBorder(),
                              enabledBorder: customBorder(),
                              focusedBorder: customBorder(),
                              disabledBorder: customBorder(),
                              focusedErrorBorder: customBorder()),
                          validator: (PhoneNumber? value) {
                            if (value!.number.isEmpty) {
                              return 'Please enter your Phone';
                            }
                            return null;
                          },
                          initialCountryCode: contryCode,//Localizations.localeOf(context).countryCode,
                          onCountryChanged: (value) {
                            setState(() {
                              phoneTextEditingController.clear();
                              phoneNumber = '';
                              contryCode = value.code;
                            });
                          },
                          onChanged: (phone) {
                            setState(() {
                              phoneNumber = phone.number;
                              contryCode = phone.countryCode;
                            });
                            print(phone);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      FadeInRight(
                        child: EditTextFormField.passwordTextField(
                          labelText: 'Password *',
                          passwordVisible: _passwordVisible,
                          textEditingController: passwordTextEditingController,
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      FadeInRight(
                        child: EditTextFormField.passwordTextField(
                          labelText:
                              'Confirm Password *', // Modify the label here
                          passwordVisible: _confirmPasswordVisible,
                          textEditingController:
                              conffPasswordTextEditingController,
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      reminderWidget(),
                      const SizedBox(
                        height: AppSize.s40,
                        width: double.infinity,
                      ),
                      FadeInRight(
                        child: Button.primaryButton(
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: getSemiBoldStyle(
                                    color: ColorManager.white, fontSize: 16),
                              ),
                            ),
                            onPressed: isLoading
                                ? () {}
                                : () async {
                                    registerNow(context);
                                  }),
                      ),
                      const SizedBox(
                        height: AppSize.s30,
                        width: double.infinity,
                      ),
                      noAccountWidget()
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> registerNow(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      if (ValidateForm.validateName(nameTextEditingController.text) != null) {
        snackBarText =
            ValidateForm.validateName(nameTextEditingController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar(snackBarText!, context));
      } else if (ValidateForm.validateEmail(emailTextEditingController.text) !=
          null) {
        snackBarText =
            ValidateForm.validateEmail(emailTextEditingController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar(snackBarText!, context));
      } else if (phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            getSnackBar(AppStrings.phoneReqErrorMessageText, context));
      } else if (ValidateForm.validatePassword(
              passwordTextEditingController.text) !=
          null) {
        snackBarText =
            ValidateForm.validatePassword(passwordTextEditingController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar(snackBarText!, context));
      } else if (_validateConfirmPassword(
              conffPasswordTextEditingController.text) !=
          null) {
        snackBarText =
            _validateConfirmPassword(conffPasswordTextEditingController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar(snackBarText!, context));
      } else {
        snackBarText = AppStrings.generalErrorMessageText;
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar(snackBarText!, context));
      }
    } else if (isChecked != true) {
      snackBarText = AppStrings.regTermsSnackbarText;
      ScaffoldMessenger.of(context)
          .showSnackBar(getSnackBar(snackBarText!, context));
    } else {
      var a = await _db
          .collection("users")
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      if (a.size == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            getSnackBar(AppStrings.mobileNotFoundErrorMessageText, context));
      } else {
        setState(() {
          isLoading = true;
        });
        EmailAuth.emailUserCredential.value = await _emailAuth.register(
            emailTextEditingController.text,
            passwordTextEditingController.text,
            context);
        if (EmailAuth.emailUserCredential.value != null) {
          User user = await EmailAuth.emailUserCredential.value.user;
          userModel = UserModel(
            uid: user.uid,
            email: user.email,
            displayName: nameTextEditingController.text,
            phoneNumber: phoneNumber,
            photoURL: user.photoURL,
            contryCode: contryCode,
            isEmailVerified: true,
          );
          print("Hello ${user.uid}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("uid", user.uid);
          prefs.setString("email", emailTextEditingController.text);
          prefs.setString("pwd", passwordTextEditingController.text);
          await _dbServices.addDataToDB("users", user.uid, userModel!.toMap());
          // await _emailAuthFootball.verifyEmail();
        }
        //await _googleAuthFootball.signOutFromGoogle();
        if (EmailAuth.val!) {
          snackBarText = AppStrings.verificationReqMessageText;
          print(snackBarText);
          ScaffoldMessenger.of(context).showSnackBar(
            getSnackBar(snackBarText!, context),
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget reminderWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
            child: isChecked
                ? const Icon(Icons.check_box_rounded)
                : const Icon(Icons.check_box_outline_blank_rounded)),
        SizedBox(
          width: MediaQuery.sizeOf(context).width - 60,
          child: RichText(
            text: TextSpan(
              style:
                  getRegularStyle(color: ColorManager.textColor, fontSize: 14),
              children: [
                const TextSpan(text: 'By signing up, you agree to our '),
                TextSpan(
                  text: 'privacy policy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.textColor, // Customize color if needed
                    // decoration: TextDecoration.underline,
                  ),
                  // Add a tap gesture if needed
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // Navigate to privacy policy page
                  // },
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: 'user terms',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.textColor, // Customize color if needed
                    // decoration: TextDecoration.underline,
                  ),
                  // Add a tap gesture if needed
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // Navigate to user terms page
                  // },
                ),
                const TextSpan(text: ', and '),
                TextSpan(
                  text: 'merchant agreement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.textColor, // Customize color if needed
                    // decoration: TextDecoration.underline,
                  ),
                  // Add a tap gesture if needed
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // Navigate to merchant agreement page
                  // },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget noAccountWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: getRegularStyle(color: ColorManager.textColor, fontSize: 14),
            children: [
              const TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorManager.textColor, // Customize color if needed
                  // decoration: TextDecoration.underline,
                ),
                // Add a tap gesture if needed
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  static UnderlineInputBorder customBorder() => UnderlineInputBorder(
      borderSide: BorderSide(color: ColorManager.buttonBorderColor));
}
