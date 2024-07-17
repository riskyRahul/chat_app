
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_fonts.dart';
import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/widget/get_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  //late StreamSubscription<InternetStatus> listener;

  String? snackBarText;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
      content: Text(
        val,
        style: getSemiBoldStyle(color: ColorManager.textColor),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.fixed,

      //  margin: EdgeInsets.only(
      //    bottom: MediaQuery.of(context).size.height - 100,
      //  right: 20,
      //left: 20),
    );
  }

  getConnectivityStatus() async {
    /* ConnectivityResult result = await Connectivity().checkConnectivity();
    print("Its here listening");
    if (result == ConnectivityResult.none) {
      print("Inside result listening");
      checkStatus();
      //return;
    } */
    bool result = await InternetConnection().hasInternetAccess;
    if (!result) {
      Navigator.pushNamed(context, '/errorscr');
    } else {
      Navigator.pushNamed(context, '/');
    }
  }

  void checkStatus() {
    snackBarText = AppStrings.checkConnectionText;
    print(snackBarText);
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      getSnackBar(snackBarText!, context),
    );

    //return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.heartImage,
              width: AppSize.s200,
              height: AppSize.s200,
            ),
            const SizedBox(
              height: AppSize.s40,
            ),
            Text(
              AppStrings.errorScreenText,
              style: getBoldStyle(
                color: ColorManager.textColor,
                fontSize: FontSize.s28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: AppSize.s12,
            ),
            Text(
              AppStrings.errorScreenText1,
              style: getRegularStyle(
                color: ColorManager.hintTextColor,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: AppSize.s27,
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: GetButtonWidget(
                  onPressed: () async {
                    await getConnectivityStatus();
                  },
                  btnText: AppStrings.errorScreenButtonText,
                  btnColor: ColorManager.primary,
                  btnTextColor: ColorManager.white),
            )
          ],
        ),
      ),
    );
  }
}
