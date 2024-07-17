// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:chat_app/constants/ui_string.dart';

class ValidateForm {
  static String? validateName(String? value) {
    if (value!.isEmpty) {
      return AppStrings.nameReqErrorMessageText;
    } else if (!RegExp(r"^[a-zA-Z]+$")
        .hasMatch(value)) {
      return AppStrings.nameValidReqErrorMessageText;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return AppStrings.emailReqErrorMessageText;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return AppStrings.emailValidReqErrorMessageText;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pwdReqErrorMessageText;
    } else if (value.length < 8 || value.length > 20) {
      return AppStrings.pwdLengthErrorMessageText;
    } else if (value.contains(' ')) {
      return AppStrings.pwdSpaceErrorMessageText;
    } else
      return null;
  }

  static String? validateDropDown(String? value) {
    if (value == null) {
      return AppStrings.teamSelectReqErrorMessageText;
    } else
      return null;
  }

  static String? validateLeagueName(String? value) {
    if (value == null || value == '') {
      return AppStrings.createLeagueScreenErrorNameText;
    } else
      return null;
  }
}
