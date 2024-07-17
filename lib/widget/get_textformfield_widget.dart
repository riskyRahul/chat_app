// ignore_for_file: must_be_immutable

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_fonts.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:flutter/material.dart';

class GetTextFormFieldWidget extends StatefulWidget {
  GetTextFormFieldWidget(
      {super.key,
      required this.inputcontroller,
      this.hintText,
      this.obscureField = false,
      this.keyBoardType = TextInputType.text,
      this.fieldActive = true,
      this.autoFocus = false,
      this.validator,
      this.fieldType = "Normal",
      this.onChanged});
  final TextEditingController inputcontroller;
  final String? hintText;
  bool obscureField;
  TextInputType keyBoardType;
  bool fieldActive;
  bool autoFocus;
  String? Function(String?)? validator;
  String fieldType;
  void Function(String)? onChanged;
  @override
  State<GetTextFormFieldWidget> createState() => _GetTextFormFieldWidgetState();
}

class _GetTextFormFieldWidgetState extends State<GetTextFormFieldWidget> {
  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: AppSize.s70,
      child: TextFormField(
        autofocus: widget.autoFocus,
        controller: widget.inputcontroller,
        enabled: widget.fieldActive,
        cursorColor: ColorManager.primary,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        /*  onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }, */
        textAlignVertical: TextAlignVertical.center,
        //textAlign: TextAlign.center,
        obscureText: widget.fieldType == "Pwd" && vis == true
            ? false
            : widget.fieldType == "Pwd" && vis == false
                ? true
                : false,
        keyboardType: widget.keyBoardType,
        style: getRegularStyle(
            color: ColorManager.hintTextColor, fontSize: FontSize.s18),
        decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 0.01),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
          contentPadding: const EdgeInsets.only(
            top: AppSize.s10,
            bottom: AppSize.s10,
            left: AppSize.s16,
          ),
          hintText: widget.hintText,
          hintStyle: getRegularStyle(
              color: ColorManager.hintTextColor, fontSize: FontSize.s18),
          isDense: true,
          suffixIcon: widget.obscureField
              ? Container(
                  height: AppSize.s70,
                  child: GestureDetector(
                      child: Icon(
                        vis ? Icons.visibility : Icons.visibility_off,
                        color: ColorManager.iconVisibilityColor,
                        size: AppSize.s25,
                      ),
                      onTap: () {
                        setState(() {
                          vis = !vis;
                        });
                      }),
                )
              : Container(
                  height: AppSize.s70,
                  child: Text(""),
                ),
          fillColor: ColorManager.offwhite,
          filled: true,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary),
            // borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorManager.formFieldBorderColor),
            // borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary),
            // borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
        ),
      ),
    );
  }
}
