import 'package:flutter/material.dart';

class AppColor {
  static Color splashScreen = HexColor('#0059b3');
  static Color primaryColor = HexColor('#18338E');
  static Color primaryWhite = HexColor('##FFFFFF');
  static Color textColor000000 = HexColor('#000000');
  static Color greyA3A3A3 = HexColor('#A3A3A3');
  static Color greyABABAB = HexColor('#ABABAB');
  static Color grey9D9D9D = HexColor('#9D9D9D');
  static Color greyC6C6C6 = HexColor('#C6C6C6');
  static Color blackColor = Colors.black;
  static Color redColor = Colors.red;
  static Color jobAlloted = HexColor('#EEFFED');
  static Color jobUpcoming = HexColor('#F3F1FE');
  static Color joboverdue = HexColor('#FFECEE');
  static Color jobwaiting = HexColor('#EEF2FB');
  static Color grey7C7C7C = HexColor('#7C7C7C');
  static Color greyF7F7F7 = HexColor('#F7F7F7');
  static Color greyF8F8F8 = HexColor('#F8F8F8FE');
  static Color ticketraisedbutton = HexColor('#EAF0FD');
  static Color customerStatus = HexColor('#898989');
  static Color technician = HexColor('#6E6E6E');
  static Color service = HexColor('#6B8AF1');
  static Color blue3E39FE = HexColor('#3E39FE');
  static Color whiteE5EFFF = HexColor('#E5EFFF');
  static Color blue19489F = HexColor('#19489F');
  static Color blue18338E = HexColor('#18338E');
  static Color greyE4E4E4 = HexColor('#E4E4E4');
  static Color greyF4F4F4= HexColor('#F4F4F4');
  static Color statusGreen = HexColor('#169D25');
  static Color statusRed = HexColor('#E24340');
  static Color statusBlue = HexColor('#3E39FE');



}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
