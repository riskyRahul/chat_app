import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class EditTextFormField {
  static Widget sempleTextField(
      {required String labelText,
      required TextEditingController textEditingController, bool isEnable=true}) {
    return TextFormField(
      enabled: isEnable,
      controller: textEditingController,
      cursorColor: ColorManager.primary,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: getRegularStyle(
              color: ColorManager.textColor, fontSize: 14, isWithShadow: false),
          border: customBorder(),
          errorBorder: customBorder(),
          enabledBorder: customBorder(),
          focusedBorder: customBorder(),
          disabledBorder: customBorder(),
          focusedErrorBorder: customBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  static Widget otpTextField(
      {required String labelText,
      required TextEditingController textEditingController}) {
    return TextFormField(
      controller: textEditingController,
      cursorColor: ColorManager.primary,
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: getRegularStyle(
              color: ColorManager.textColor, fontSize: 14, isWithShadow: false),
          border: customBorder(),
          errorBorder: customBorder(),
          enabledBorder: customBorder(),
          focusedBorder: customBorder(),
          disabledBorder: customBorder(),
          focusedErrorBorder: customBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  static UnderlineInputBorder customBorder() => UnderlineInputBorder(
      borderSide: BorderSide(color: ColorManager.buttonBorderColor));

  static Widget passwordTextField(
      {required String labelText,
      required bool passwordVisible,
      required VoidCallback onPressed,
      required TextEditingController textEditingController}) {
    return TextFormField(
      controller: textEditingController,
      cursorColor: ColorManager.primary,
      obscureText: passwordVisible,
      decoration: InputDecoration(
          labelText: labelText, // Modify the label here
          suffixIcon: GestureDetector(
            onTap: onPressed,
            child: Icon(
              !passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: !passwordVisible
                  ? ColorManager.textColor
                  : ColorManager.hintTextColor,
            ),
          ),
          labelStyle: getRegularStyle(
              color: ColorManager.textColor, fontSize: 14, isWithShadow: false),
          border: customBorder(),
          errorBorder: customBorder(),
          enabledBorder: customBorder(),
          focusedBorder: customBorder(),
          disabledBorder: customBorder(),
          focusedErrorBorder: customBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  static Widget searchTextField(
      {required VoidCallback onTap,
      required VoidCallback suffixIconOnTap,
      required Function(String) onchange,
      required String hintText,
      bool isEnable = true,
      required TextEditingController textEditingController,
      int borderRedus = 50,
      bool showsuffixIcon = true}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: TextFormField(
          enabled: isEnable,
          onChanged: onchange,
          controller: textEditingController,
          cursorColor: ColorManager.primary,
          decoration: InputDecoration(
              fillColor: ColorManager.textfieldFillColor,
              filled: true,
              
              prefixIcon: SizedBox(
                  height: 24,
                  width: 24,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(IconsAssets.searchIcoon),
                  )),
              suffixIcon: showsuffixIcon
                  ? GestureDetector(
                      onTap: suffixIconOnTap,
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(IconsAssets.closeIcoon),
                          )),
                    )
                  : const SizedBox(),
              hintText: hintText,
              hintStyle: getRegularStyle(
                  color: ColorManager.textColor,
                  fontSize: 14,
                  isWithShadow: false),
              border: searchCustomBorder(borderRedus),
              errorBorder: searchCustomBorder(borderRedus),
              enabledBorder: searchCustomBorder(borderRedus),
              focusedBorder: searchCustomBorder(borderRedus),
              disabledBorder: searchCustomBorder(borderRedus),
              focusedErrorBorder: searchCustomBorder(borderRedus)),
        ),
      ),
    );
  }

  static OutlineInputBorder searchCustomBorder(int borderRadius) =>
      OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.toDouble()),
          borderSide: const BorderSide(color: Colors.transparent));
}
