// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:chat_app/auth/email_auth.dart';
import 'package:chat_app/auth/google_auth.dart';
import 'package:chat_app/auth/phone_auth.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_fonts.dart';
import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/login_ui_model.dart';
import 'package:chat_app/screens/auth/register_page.dart';
import 'package:chat_app/utils/validators_util.dart';
import 'package:chat_app/widget/button.dart';
import 'package:chat_app/widget/get_button_widget.dart';
import 'package:chat_app/widget/get_textformfield_widget.dart';
import 'package:chat_app/widget/text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleAuth _googleAuth = GoogleAuth();
  final EmailAuth _emailAuth = EmailAuth();
  final PhoneAuth _phoneAuth = PhoneAuth();
  final _formKey = GlobalKey<FormState>();
  final _fgtFormKey = GlobalKey<FormState>();

  bool _passwordVisible = true;
  bool isChecked = false;

  String fullPhoneNumber = '';
  String mPhone = '';
  TextEditingController otpTextEditingController = TextEditingController();
  TextEditingController mobileTextEditingController = TextEditingController();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController fgtEmailTextEditingController = TextEditingController();

  final List<LoginUIModel> _list = [
    LoginUIModel(titel: "Email", id: 1),
    LoginUIModel(titel: "Phone Number", id: 2)
  ];
  int slectedTab = 0;

  String? snackBarText;

  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
      content: Text(
        val,
        style: getSemiBoldStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    );
  }

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
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Welcome Back!',
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
                      FadeInRight(
                        child: Container(
                          height: 54,
                          margin: const EdgeInsets.symmetric(
                              vertical: AppMargin.m18),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorManager.buttonBorderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => setState(() => slectedTab = index),
                                child: Container(
                                  margin: const EdgeInsets.all(AppMargin.m4),
                                  width:
                                      MediaQuery.sizeOf(context).width / 2 - 24,
                                  decoration: BoxDecoration(
                                    color: slectedTab == index
                                        ? ColorManager.white
                                        : ColorManager.buttonBorderColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _list[index].titel,
                                      style: getSemiBoldStyle(
                                          color: ColorManager.primary),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      selectedTabUI(_list[slectedTab]),
                      const SizedBox(
                        height: AppSize.s30,
                        width: double.infinity,
                      ),
                      FadeInRight(child: customDivider()),
                      const SizedBox(
                        height: AppSize.s30,
                        width: double.infinity,
                      ),
                      ValueListenableBuilder(
                        valueListenable: GoogleAuth.userCredential,
                        builder: (context, value, child) {
                          return (GoogleAuth.userCredential.value == '' ||
                                  GoogleAuth.userCredential.value == null)
                              ? FadeInLeft(
                                  child: Button.secondaryButton(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                IconsAssets.googlelogo),
                                            const SizedBox(width: AppSize.s8),
                                            Text(
                                              "Continue with Google",
                                              style: getSemiBoldStyle(
                                                  color: ColorManager.primary,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () async {
                                        GoogleAuth.userCredential.value =
                                            await _googleAuth
                                                .registerWithGoogle(context);
                                        if (GoogleAuth.userCredential.value ==
                                                '' ||
                                            GoogleAuth.userCredential.value ==
                                                null) {
                                        } else {
                                          print(GoogleAuth.userCredential.value
                                              .user!.email);
                                        }
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      color: ColorManager.primary, value: .5),
                                );
                        },
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                        width: double.infinity,
                      ),
                      // Platform.isIOS
                      //     ? FadeInRight(
                      //         child: Button.secondaryButton(
                      //             child: Center(
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   SvgPicture.asset(IconsAssets.applelogo),
                      //                   const SizedBox(width: AppSize.s8),
                      //                   Text(
                      //                     "Continue with Apple",
                      //                     style: getSemiBoldStyle(
                      //                         color: ColorManager.primary,
                      //                         fontSize: 16),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             onPressed: () {
                      //               Navigator.pushReplacement(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           const CongratulationsScreen()));
                      //             }),
                      //       )
                      //     : const SizedBox(),
                      const SizedBox(
                        height: AppSize.s30,
                        width: double.infinity,
                      ),
                      FadeInRight(child: noAccountWidget())
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectedTabUI(LoginUIModel loginUIModel) {
    switch (loginUIModel.id) {
      case 1:
        return loginWithEmail();
      case 2:
        return loginWithPhone();
      default:
        return loginWithEmail();
    }
  }

  bool isShowOtp = false;
  String verifactionId = "";

  Column loginWithPhone() {
    return Column(
      children: [
        // FadeInRight(
        //   child: EditTextFormField.sempleTextField(
        //       labelText: 'Phone Number *',
        //       textEditingController: mobileTextEditingController),
        // ),
        FadeInRight(
          child: IntlPhoneField(
            cursorColor: ColorManager.primary,
            controller: mobileTextEditingController,
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
            initialCountryCode: contryCode,
            onCountryChanged: (value) {
              setState(() {
                mobileTextEditingController.clear();
                fullPhoneNumber = '';
                mPhone = '';
              });
            },
            onChanged: (phone) {
              setState(() {
                mPhone = phone.number;
                fullPhoneNumber=phone.completeNumber;
              });
            },
          ),
        ),

        const SizedBox(
          height: AppSize.s20,
          width: double.infinity,
        ),
        isShowOtp
            ? FadeInRight(
                child: EditTextFormField.otpTextField(
                  labelText: 'OTP *',
                  textEditingController: otpTextEditingController,
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: AppSize.s30,
          width: double.infinity,
        ),
        !isShowOtp
            ? FadeInRight(
                child: Button.primaryButton(
                    child: Center(
                      child: Text(
                        "Verify Phone",
                        style: getSemiBoldStyle(
                            color: ColorManager.white, fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _phoneAuth.phoneVerify(
                            context: context,
                            fullPhoneNumber: fullPhoneNumber,
                            phone: mPhone,
                            codeAutoRetrievalTimeout: (p0) {},
                            codeSent: (p0, p1) {
                              setState(() {
                                isShowOtp = true;
                                verifactionId = p0;
                              });
                              print(p0);
                            },
                            verificationCompleted: (p0) {},
                            verificationFailed: (p0) {
                              print(p0);
                            });
                      }
                    }),
              )
            : FadeInRight(
                child: Button.primaryButton(
                    child: Center(
                      child: Text(
                        "Login",
                        style: getSemiBoldStyle(
                            color: ColorManager.white, fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (verifactionId.isNotEmpty) {
                          _phoneAuth.signInWithPhoneNumber(
                            phone: mPhone,
                              otp: otpTextEditingController.text,
                              verificationId: verifactionId,
                              context: context);
                        }
                      }
                    }),
              ),
      ],
    );
  }

  Column loginWithEmail() {
    return Column(
      children: [
        FadeInRight(
          child: EditTextFormField.sempleTextField(
              labelText: 'Email *',
              textEditingController: emailTextEditingController),
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
        reminderWidget(),
        const SizedBox(
          height: AppSize.s30,
          width: double.infinity,
        ),
        FadeInRight(
          child: ValueListenableBuilder(
              valueListenable: EmailAuth.loginEmailUserCredential,
              builder: (context, value, child) {
                return (EmailAuth.loginEmailUserCredential.value == '' ||
                        EmailAuth.loginEmailUserCredential.value == null)
                    ? Button.primaryButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            if (ValidateForm.validateEmail(
                                    emailTextEditingController.text) !=
                                null) {
                              snackBarText = ValidateForm.validateEmail(
                                  emailTextEditingController.text);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  getSnackBar(snackBarText!, context));
                            } else if (ValidateForm.validatePassword(
                                    passwordTextEditingController.text) !=
                                null) {
                              snackBarText = ValidateForm.validatePassword(
                                  passwordTextEditingController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  getSnackBar(snackBarText!, context));
                            }
                          } else {
                            EmailAuth.loginEmailUserCredential.value =
                                await _emailAuth.emailLogin(
                                    emailTextEditingController.text,
                                    passwordTextEditingController.text,
                                    context);
                            if (!EmailAuth.verifiedEmail!) {
                              snackBarText =
                                  AppStrings.verifyMailErrorMessageText;
                              print(snackBarText);
                               ScaffoldMessenger.of(context).showSnackBar(
                                getSnackBar(snackBarText!, context),
                              );
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            "Login",
                            style: getSemiBoldStyle(
                                color: ColorManager.white, fontSize: 16),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          value: .5,
                        ),
                      );
              }),
        ),
      ],
    );
  }

  Widget reminderWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const SizedBox(width: AppSize.s10),
        Text("Remember me",
            style:
                getRegularStyle(color: ColorManager.textColor, fontSize: 14)),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            await forgotPassword();
          },
          child: Text("Forgot password?",
              style: getRegularStyle(
                  color: ColorManager.hintTextColor, fontSize: 14)),
        ),
      ],
    );
  }

  Row customDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ColorManager.grey2,
            thickness: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or',
            style: getSemiBoldStyle(color: ColorManager.hintTextColor),
          ),
        ),
        Expanded(
          child: Divider(
            color: ColorManager.grey2,
            thickness: 0.5,
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
              const TextSpan(text: 'Dont’t have an account? '),
              TextSpan(
                text: 'Register',
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
                            builder: (context) => const RegisterScreen()));
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
  Future<void> forgotPassword() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return SizedBox(
            width: width * .8,
            height: height * .3,
            child: AlertDialog(
                alignment: Alignment(0, .25),
                elevation: 0,
                title: Text(
                  AppStrings.forgotPwdText,
                  style: getSemiBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s18),
                ),
                //titlePadding: EdgeInsets.all(20),
                iconPadding: const EdgeInsets.only(left: 280),
                icon: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: ColorManager.primary,
                    size: AppSize.s40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                content: Builder(
                  builder: (context) {
                    return SizedBox(
                      width: width * .7,
                      height: height * .28,
                      child: Form(
                        key: _fgtFormKey,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.emailText,
                                style: getSemiBoldStyle(
                                  color: ColorManager.textColor,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                              const SizedBox(
                                height: AppMargin.m8,
                              ),
                              GetTextFormFieldWidget(
                                inputcontroller: fgtEmailTextEditingController,
                                hintText: 'es: mario_rossi@safeemail.com',
                                validator: ValidateForm.validateEmail,
                              ),
                              const SizedBox(
                                height: AppSize.s45,
                              ),
                              GetButtonWidget(
                                  onPressed: () async {
                                    if (!_fgtFormKey.currentState!.validate()) {
                                      if (ValidateForm.validateEmail(
                                              fgtEmailTextEditingController.text
                                                  .trim()) !=
                                          null) {
                                        //print('HEllo');
                                        snackBarText =
                                            ValidateForm.validateEmail(
                                                fgtEmailTextEditingController
                                                    .text);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(getSnackBar(
                                                snackBarText!, context));
                                      } else {
                                        //print(
                                        //  _fgtEmailController
                                        //    .text);
                                        await _emailAuth.sendPasswordResetEmail(
                                            fgtEmailTextEditingController.text
                                                .trim(),
                                            context);
                                      }
                                    }
                                  },
                                  btnText: AppStrings.fgtSubmitText,
                                  btnColor: ColorManager.primary,
                                  btnTextColor: ColorManager.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          );
        });
  }
}
