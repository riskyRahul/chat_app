import 'package:flutter/material.dart';

MaterialColor black = const MaterialColor(0xFF000000, {
  50: Colors.black,
  100: Colors.black,
  200: Colors.black,
  300: Colors.black,
  400: Colors.black,
  500: Colors.black,
  600: Colors.black,
  700: Colors.black,
  800: Colors.black,
  900: Colors.black
});

class ColorManager {
  static Color primary = black;
  static Color c454545 = HexColor.fromHex('#454545');
  static Color textColor = HexColor.fromHex('#202226');
  static Color hintTextColor = HexColor.fromHex("#838383");
  static Color offwhite = HexColor.fromHex('#F9F9F9');
  static Color iconVisibilityColor = HexColor.fromHex('#4B4B4B');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color recColor = HexColor.fromHex("#D91E66");
  static Color buttonColor = HexColor.fromHex("#B22159");
  static Color buttonColor1 = HexColor.fromHex("#EEF2FA");
  static Color bottomBarColor = HexColor.fromHex("#202226");
  static Color buttonBorderColor = HexColor.fromHex("#EDEDED");
  static Color logoutbuttonBorderColor = HexColor.fromHex("#EA3434");
  static Color textfieldFillColor = HexColor.fromHex("#F6F8FA");
  static Color formFieldBorderColor = HexColor.fromHex("#0000FF");
  static Color grey = HexColor.fromHex('#4B4B4B');
  static Color homeScreenAppBarColor = HexColor.fromHex("#D61872");
  static Color homeScreenAppBarColor1 = HexColor.fromHex("#C30760");
  static Color homeScreentabColor2 = HexColor.fromHex("#5C6371");
  static Color leagueWidgetColor = HexColor.fromHex("#4A4949");
  static Color leagueTextColor1 = HexColor.fromHex("#EEF2FA");
  static Color fbfbfb = HexColor.fromHex("#FBFBFB");
  static Color ededed = HexColor.fromHex("#EDEDED");
  static Color leagueCircleColor1 = HexColor.fromHex("#C9CFDB");
  static Color leagueDividerColor = HexColor.fromHex("#616161");
  static Color createleagueTextColor = HexColor.fromHex("#7D7D7D");
  static Color dottedBorderColor = HexColor.fromHex("#A3A3A3");
  static Color unselectedItemColor = HexColor.fromHex("#A7B1C6");
  static Color settingsBackgroundColor = HexColor.fromHex("#EEF2FA");
  static Color settingsTextColor = HexColor.fromHex("#5C6371");
  static Color settingsSubTextColor = HexColor.fromHex("#848383");
  static Color arrowBackColor = HexColor.fromHex("#F3F6FB");
  static Color c0019FF = HexColor.fromHex("#0019FF");
  static Color f2F2F2 = HexColor.fromHex('#F2F2F2');
  static Color c1C1C1 = HexColor.fromHex('#C1C1C1');
  static Color fCA657 = HexColor.fromHex('#FCA657');
  static Color c44B461 = HexColor.fromHex('#44B461');
  static Color c28C937 = HexColor.fromHex('#28C937');
  static Color cD9D9D9 = HexColor.fromHex('#D9D9D9');
  static Color day10RadioCircleActiveColor = HexColor.fromHex('#44B461');
  static Color day10RadioCircleActiveColor2 = HexColor.fromHex('#F5F5F5');

  static Color survivorDropDownColor = HexColor.fromHex('#F3F6FB');
  static Color survivorExtendedTextColor1 = HexColor.fromHex('#9A9A9A');
  static Color collectionBg = HexColor.fromHex('#E5E7EB');

  static Color darkGrey = HexColor.fromHex('#525252');
  static Color lightGrey = HexColor.fromHex('#9E9E9E');
  static Color primaryOpacity70 = HexColor.fromHex('#B3ED9728');

  static Color darkPrimary = HexColor.fromHex('#D17D11');
  static Color grey1 = HexColor.fromHex('#707070');
  static Color grey2 = HexColor.fromHex('#797979');

  static Color error = HexColor.fromHex('#E61F34');
}

extension HexColor on Color {
  static Color fromHex(String hexColorSting) {
    hexColorSting = hexColorSting.replaceAll('#', '');
    if (hexColorSting.length == 6) {
      hexColorSting = 'FF$hexColorSting';
    }
    return Color(int.parse(hexColorSting, radix: 16));
  }
}
