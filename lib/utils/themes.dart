import 'package:flutter/material.dart';
import 'package:themed/themed.dart';

class BaseThemeColors {
  //Main
  static const mainAppBarBG = ColorRef(Colors.white, id: 'Main1');
  static const mainAppBarText = ColorRef(Colors.white, id: 'Main2');
  static const mainMenuLogoBG = ColorRef(Colors.white, id: 'Main3');
  static const mainMenuListBG = ColorRef(Colors.white, id: 'Main4');
  static const mainMenuListText = ColorRef(Colors.white, id: 'Main5');
  //Dex
  static const dexBGGradientTop = ColorRef(Colors.white, id: 'Dex1');
  static const dexBGGradientBottom = ColorRef(Colors.blue, id: 'Dex2');
  static const dexItemBG = ColorRef(Colors.green, id: 'Dex3');
  static const dexItemText = ColorRef(Colors.green, id: 'Dex4');
  static const dexItemAccentText = ColorRef(Colors.green, id: 'Dex5');
  //FAB
  static const fabBG = ColorRef(Colors.white, id: 'Fab1');
  static const fabText = ColorRef(Colors.blue, id: 'Fab2');
  static const fabPopupBG = ColorRef(Colors.green, id: 'Fab3');
  static const fabPopupText = ColorRef(Colors.green, id: 'Fab4');
  static const fabPopupButtonBG = ColorRef(Colors.green, id: 'Fab5');
  static const fabPopupButtonText = ColorRef(Colors.green, id: 'Fab6');
  //Detail + Settings
  static const detailBGGradientTop = ColorRef(Colors.white, id: 'Detail1');
  static const detailBGGradientBottom = ColorRef(Colors.blue, id: 'Detail2');
  static const detailAppBarBG = ColorRef(Colors.green, id: 'Detail3');
  static const detailAppBarText = ColorRef(Colors.green, id: 'Detail4');
  static const detailContainerGradientTop = ColorRef(Colors.green, id: 'Detail5');
  static const detailContainerGradientBottom = ColorRef(Colors.green, id: 'Detail6');
  static const detailContainerText = ColorRef(Colors.green, id: 'Detail7');
  static const detailButtonBG = ColorRef(Colors.green, id: 'Detail8');
  static const detailButtonText = ColorRef(Colors.green, id: 'Detail9');
  static const detailNavBarBG = ColorRef(Colors.green, id: 'Detail10');
  static const detailNavBarText = ColorRef(Colors.green, id: 'Detail11');
  static const detailItemBg = ColorRef(Colors.green, id: 'Detail12');
  static const detailItemText = ColorRef(Colors.green, id: 'Detail13');
  static const detailItemAccentText = ColorRef(Colors.green, id: 'Detail14');

  static Map<ThemeRef, Object> rotomTheme = {
    //Main
    BaseThemeColors.mainAppBarBG: const Color(0xFF6ae2f2),
    BaseThemeColors.mainAppBarText: Colors.black,
    BaseThemeColors.mainMenuLogoBG: const Color(0xFFEF866B),
    BaseThemeColors.mainMenuListBG: const Color(0xFF6ae2f2),
    BaseThemeColors.mainMenuListText: Colors.black,
    //Dex
    BaseThemeColors.dexBGGradientTop: const Color(0xFF32A6B0),
    BaseThemeColors.dexBGGradientBottom: const Color(0xFF3DC8B6),
    BaseThemeColors.dexItemBG: Colors.teal,
    BaseThemeColors.dexItemText: Colors.white,
    BaseThemeColors.dexItemAccentText: const Color.fromARGB(170, 255, 255, 255),
    //FAB
    BaseThemeColors.fabBG: const Color(0xFFEF866B),
    BaseThemeColors.fabText: Colors.white,
    BaseThemeColors.fabPopupBG: const Color(0xFFEF866B),
    BaseThemeColors.fabPopupText: Colors.white,
    BaseThemeColors.fabPopupButtonBG: const Color(0xFF878787),
    BaseThemeColors.fabPopupButtonText: Colors.white,
    //Detail
    BaseThemeColors.detailBGGradientTop: const Color(0xFF64B6ED),
    BaseThemeColors.detailBGGradientBottom: const Color(0xFFB7FCFB),
    BaseThemeColors.detailAppBarBG: const Color(0xFF585B66),
    BaseThemeColors.detailAppBarText: Colors.white,
    BaseThemeColors.detailContainerGradientTop: Colors.white,
    BaseThemeColors.detailContainerGradientBottom: const Color(0xFFC6C6C6),
    BaseThemeColors.detailContainerText: Colors.black,
    BaseThemeColors.detailButtonBG: const Color(0xFFEF866B),
    BaseThemeColors.detailButtonText: Colors.white,
    BaseThemeColors.detailNavBarBG: Colors.white,
    BaseThemeColors.detailNavBarText: Colors.black,
    BaseThemeColors.detailItemBg: Colors.teal,
    BaseThemeColors.detailItemText: Colors.black,
    BaseThemeColors.detailItemAccentText: const Color.fromARGB(170, 0, 0, 0),
  };

  static Map<ThemeRef, Object> lightTheme = {
    //Main
    BaseThemeColors.mainAppBarBG: Colors.white,
    BaseThemeColors.mainAppBarText: Colors.black,
    BaseThemeColors.mainMenuLogoBG: const Color(0xFFEF866B),
    BaseThemeColors.mainMenuListBG: Colors.white,
    BaseThemeColors.mainMenuListText: Colors.black,
    //Dex
    BaseThemeColors.dexBGGradientTop: const Color(0xffE2E2E2),
    BaseThemeColors.dexBGGradientBottom: const Color(0xffE2E2E2),
    BaseThemeColors.dexItemBG: Colors.white,
    BaseThemeColors.dexItemText: Colors.black,
    BaseThemeColors.dexItemAccentText: const Color.fromARGB(170, 0, 0, 0),
    //FAB
    BaseThemeColors.fabBG: const Color(0xFFEF866B),
    BaseThemeColors.fabText: Colors.white,
    BaseThemeColors.fabPopupBG: Colors.white,
    BaseThemeColors.fabPopupText: Colors.black,
    BaseThemeColors.fabPopupButtonBG: const Color(0xFF878787),
    BaseThemeColors.fabPopupButtonText: Colors.black,
    //Detail
    BaseThemeColors.detailBGGradientTop: const Color(0xffE2E2E2),
    BaseThemeColors.detailBGGradientBottom: const Color(0xffE2E2E2),
    BaseThemeColors.detailAppBarBG: Colors.white,
    BaseThemeColors.detailAppBarText: Colors.black,
    BaseThemeColors.detailContainerGradientTop: Colors.white,
    BaseThemeColors.detailContainerGradientBottom: Colors.white,
    BaseThemeColors.detailContainerText: Colors.black,
    BaseThemeColors.detailButtonBG: const Color(0xFFEF866B),
    BaseThemeColors.detailButtonText: Colors.white,
    BaseThemeColors.detailNavBarBG: Colors.white,
    BaseThemeColors.detailNavBarText: Colors.black,
    BaseThemeColors.detailItemBg: const Color(0xffE2E2E2),
    BaseThemeColors.detailItemText: Colors.black,
    BaseThemeColors.detailItemAccentText: const Color.fromARGB(170, 0, 0, 0),
  };

  static Map<ThemeRef, Object> darkTheme = {
    //Main
    BaseThemeColors.mainAppBarBG: const Color(0xff222222),
    BaseThemeColors.mainAppBarText: Colors.white,
    BaseThemeColors.mainMenuLogoBG: const Color(0xFFEF866B),
    BaseThemeColors.mainMenuListBG: const Color(0xff222222),
    BaseThemeColors.mainMenuListText: Colors.white,
    //Dex
    BaseThemeColors.dexBGGradientTop: const Color(0xff181818),
    BaseThemeColors.dexBGGradientBottom: const Color(0xff181818),
    BaseThemeColors.dexItemBG: const Color(0xff222222),
    BaseThemeColors.dexItemText: Colors.white,
    BaseThemeColors.dexItemAccentText: const Color.fromARGB(170, 255, 255, 255),
    //FAB
    BaseThemeColors.fabBG: const Color(0xFFEF866B),
    BaseThemeColors.fabText: Colors.white,
    BaseThemeColors.fabPopupBG: const Color.fromARGB(255, 25, 25, 25),
    BaseThemeColors.fabPopupText: Colors.white,
    BaseThemeColors.fabPopupButtonBG: const Color(0xFF878787),
    BaseThemeColors.fabPopupButtonText: Colors.white,
    //Detail
    BaseThemeColors.detailBGGradientTop: const Color(0xff181818),
    BaseThemeColors.detailBGGradientBottom: const Color(0xff181818),
    BaseThemeColors.detailAppBarBG: const Color(0xff222222),
    BaseThemeColors.detailAppBarText: Colors.white,
    BaseThemeColors.detailContainerGradientTop: const Color(0xff222222),
    BaseThemeColors.detailContainerGradientBottom: const Color(0xff222222),
    BaseThemeColors.detailContainerText: Colors.white,
    BaseThemeColors.detailButtonBG: const Color(0xFFEF866B),
    BaseThemeColors.detailButtonText: Colors.white,
    BaseThemeColors.detailNavBarBG: Colors.white,
    BaseThemeColors.detailNavBarText: Colors.black,
    BaseThemeColors.detailItemBg: const Color(0xff181818),
    BaseThemeColors.detailItemText: Colors.white,
    BaseThemeColors.detailItemAccentText: const Color.fromARGB(170, 255, 255, 255),
  };
}
