import 'package:flutter/material.dart';

class LeoJayApp extends InheritedWidget {
  ColorTheme _ct = ColorTheme.LIGHT;

  _ColorRes get colors => _ColorRes(_ct);

  _FontRes get font => _FontRes();

  Language _language = Language.CN;

  _StringRes get string => _StringRes(_language);

  LeoJayApp({ColorTheme? ct, Language? language, required super.child}) {
    if (null != ct) _ct = ct;
    if (null != language) _language = language;
  }

  static LeoJayApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LeoJayApp>()!;
  }

  @override
  bool updateShouldNotify(LeoJayApp oldWidget) {
    return _ct != oldWidget._ct;
  }
}

class ColorSchemeApp extends InheritedWidget {
  ColorTheme _ct = ColorTheme.LIGHT;

  _ColorRes get colors => _ColorRes(_ct);

  _FontRes get font => _FontRes();

  Language _language = Language.CN;

  _StringRes get string => _StringRes(_language);

  ColorSchemeApp({ColorTheme? ct, Language? language, required super.child}) {
    if (null != ct) _ct = ct;
    if (null != language) _language = language;
  }

  static ColorSchemeApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColorSchemeApp>()!;
  }

  @override
  bool updateShouldNotify(ColorSchemeApp oldWidget) {
    return _ct != oldWidget._ct;
  }
}

enum ColorTheme { LIGHT, DARK }

class _ColorRes {
  ColorTheme _ct;

  _ColorRes(this._ct);

  Color get primary_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffcfcfc),
      ColorTheme.DARK => const Color(0xff111113),
      _ => const Color(0xfffcfcfc),
    };
  }

  Color get primary_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfff9f9f9),
      ColorTheme.DARK => const Color(0xff19191b),
      _ => const Color(0xfff9f9f9),
    };
  }

  Color get primary_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffefefef),
      ColorTheme.DARK => const Color(0xff222325),
      _ => const Color(0xffefefef),
    };
  }

  Color get primary_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe8e8e8),
      ColorTheme.DARK => const Color(0xff292a2e),
      _ => const Color(0xffe8e8e8),
    };
  }

  Color get primary_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe0e0e0),
      ColorTheme.DARK => const Color(0xff303136),
      _ => const Color(0xffe0e0e0),
    };
  }

  Color get primary_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffd8d8d8),
      ColorTheme.DARK => const Color(0xff393a40),
      _ => const Color(0xffd8d8d8),
    };
  }

  Color get primary_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffcecece),
      ColorTheme.DARK => const Color(0xff46484f),
      _ => const Color(0xffcecece),
    };
  }

  Color get primary_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffbbbbbb),
      ColorTheme.DARK => const Color(0xff5f606a),
      _ => const Color(0xffbbbbbb),
    };
  }

  Color get primary_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff000000),
      ColorTheme.DARK => const Color(0xffffffff),
      _ => const Color(0xff000000),
    };
  }

  Color get primary_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff2e2e2e),
      ColorTheme.DARK => const Color(0xfff5f6f8),
      _ => const Color(0xff2e2e2e),
    };
  }

  Color get primary_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff646464),
      ColorTheme.DARK => const Color(0xffb2b3bd),
      _ => const Color(0xff646464),
    };
  }

  Color get primary_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff202020),
      ColorTheme.DARK => const Color(0xffeeeef0),
      _ => const Color(0xff202020),
    };
  }

  Color get primary_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000003),
      ColorTheme.DARK => const Color(0x1111bb03),
      _ => const Color(0x00000003),
    };
  }

  Color get primary_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000006),
      ColorTheme.DARK => const Color(0xcbcbf90b),
      _ => const Color(0x00000006),
    };
  }

  Color get primary_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000010),
      ColorTheme.DARK => const Color(0xd6e2f916),
      _ => const Color(0x00000010),
    };
  }

  Color get primary_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000017),
      ColorTheme.DARK => const Color(0xd1d9f920),
      _ => const Color(0x00000017),
    };
  }

  Color get primary_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0000001f),
      ColorTheme.DARK => const Color(0xd7ddfd28),
      _ => const Color(0x0000001f),
    };
  }

  Color get primary_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000027),
      ColorTheme.DARK => const Color(0xd9defc33),
      _ => const Color(0x00000027),
    };
  }

  Color get primary_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000031),
      ColorTheme.DARK => const Color(0xdae2fd43),
      _ => const Color(0x00000031),
    };
  }

  Color get primary_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000044),
      ColorTheme.DARK => const Color(0xe0e3fd60),
      _ => const Color(0x00000044),
    };
  }

  Color get primary_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff000000),
      ColorTheme.DARK => const Color(0xffffffff),
      _ => const Color(0xff000000),
    };
  }

  Color get primary_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x000000d1),
      ColorTheme.DARK => const Color(0xfcfdfff8),
      _ => const Color(0x000000d1),
    };
  }

  Color get primary_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0000009b),
      ColorTheme.DARK => const Color(0xeff0feb9),
      _ => const Color(0x0000009b),
    };
  }

  Color get primary_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x000000df),
      ColorTheme.DARK => const Color(0xfdfdffef),
      _ => const Color(0x000000df),
    };
  }

  Color get neutral_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffcfcfc),
      ColorTheme.DARK => const Color(0xff111113),
      _ => const Color(0xfffcfcfc),
    };
  }

  Color get neutral_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfff9f9f9),
      ColorTheme.DARK => const Color(0xff19191b),
      _ => const Color(0xfff9f9f9),
    };
  }

  Color get neutral_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffefefef),
      ColorTheme.DARK => const Color(0xff222325),
      _ => const Color(0xffefefef),
    };
  }

  Color get neutral_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe8e8e8),
      ColorTheme.DARK => const Color(0xff292a2e),
      _ => const Color(0xffe8e8e8),
    };
  }

  Color get neutral_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe0e0e0),
      ColorTheme.DARK => const Color(0xff303136),
      _ => const Color(0xffe0e0e0),
    };
  }

  Color get neutral_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffd8d8d8),
      ColorTheme.DARK => const Color(0xff393a40),
      _ => const Color(0xffd8d8d8),
    };
  }

  Color get neutral_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffcecece),
      ColorTheme.DARK => const Color(0xff46484f),
      _ => const Color(0xffcecece),
    };
  }

  Color get neutral_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffbbbbbb),
      ColorTheme.DARK => const Color(0xff5f606a),
      _ => const Color(0xffbbbbbb),
    };
  }

  Color get neutral_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff8d8d8d),
      ColorTheme.DARK => const Color(0xff6c6e79),
      _ => const Color(0xff8d8d8d),
    };
  }

  Color get neutral_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff838383),
      ColorTheme.DARK => const Color(0xff797b86),
      _ => const Color(0xff838383),
    };
  }

  Color get neutral_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff646464),
      ColorTheme.DARK => const Color(0xffb2b3bd),
      _ => const Color(0xff646464),
    };
  }

  Color get neutral_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff202020),
      ColorTheme.DARK => const Color(0xffeeeef0),
      _ => const Color(0xff202020),
    };
  }

  Color get neutral_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000003),
      ColorTheme.DARK => const Color(0x1111bb03),
      _ => const Color(0x00000003),
    };
  }

  Color get neutral_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000006),
      ColorTheme.DARK => const Color(0xcbcbf90b),
      _ => const Color(0x00000006),
    };
  }

  Color get neutral_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000010),
      ColorTheme.DARK => const Color(0xd6e2f916),
      _ => const Color(0x00000010),
    };
  }

  Color get neutral_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000017),
      ColorTheme.DARK => const Color(0xd1d9f920),
      _ => const Color(0x00000017),
    };
  }

  Color get neutral_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0000001f),
      ColorTheme.DARK => const Color(0xd7ddfd28),
      _ => const Color(0x0000001f),
    };
  }

  Color get neutral_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000027),
      ColorTheme.DARK => const Color(0xd9defc33),
      _ => const Color(0x00000027),
    };
  }

  Color get neutral_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000031),
      ColorTheme.DARK => const Color(0xdae2fd43),
      _ => const Color(0x00000031),
    };
  }

  Color get neutral_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000044),
      ColorTheme.DARK => const Color(0xe0e3fd60),
      _ => const Color(0x00000044),
    };
  }

  Color get neutral_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00000072),
      ColorTheme.DARK => const Color(0xe0e4fd70),
      _ => const Color(0x00000072),
    };
  }

  Color get neutral_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0000007c),
      ColorTheme.DARK => const Color(0xe3e7fd7e),
      _ => const Color(0x0000007c),
    };
  }

  Color get neutral_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0000009b),
      ColorTheme.DARK => const Color(0xeff0feb9),
      _ => const Color(0x0000009b),
    };
  }

  Color get neutral_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x000000df),
      ColorTheme.DARK => const Color(0xfdfdffef),
      _ => const Color(0x000000df),
    };
  }

  Color get red_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffffcfc),
      ColorTheme.DARK => const Color(0xff160f0e),
      _ => const Color(0xfffffcfc),
    };
  }

  Color get red_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffff8f7),
      ColorTheme.DARK => const Color(0xff1e1512),
      _ => const Color(0xfffff8f7),
    };
  }

  Color get red_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffeebe7),
      ColorTheme.DARK => const Color(0xff381710),
      _ => const Color(0xfffeebe7),
    };
  }

  Color get red_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffffdcd3),
      ColorTheme.DARK => const Color(0xff4e160b),
      _ => const Color(0xffffdcd3),
    };
  }

  Color get red_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffffcdc1),
      ColorTheme.DARK => const Color(0xff5e1d10),
      _ => const Color(0xffffcdc1),
    };
  }

  Color get red_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffdbdae),
      ColorTheme.DARK => const Color(0xff6d2a1c),
      _ => const Color(0xfffdbdae),
    };
  }

  Color get red_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfff5a997),
      ColorTheme.DARK => const Color(0xff853b2b),
      _ => const Color(0xfff5a997),
    };
  }

  Color get red_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffec8f7a),
      ColorTheme.DARK => const Color(0xffac4d39),
      _ => const Color(0xffec8f7a),
    };
  }

  Color get red_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe54d2e),
      ColorTheme.DARK => const Color(0xffe54d2e),
      _ => const Color(0xffe54d2e),
    };
  }

  Color get red_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffd73d1d),
      ColorTheme.DARK => const Color(0xffd63e1f),
      _ => const Color(0xffd73d1d),
    };
  }

  Color get red_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffcf3716),
      ColorTheme.DARK => const Color(0xffff9277),
      _ => const Color(0xffcf3716),
    };
  }

  Color get red_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff5c281c),
      ColorTheme.DARK => const Color(0xfffbd3ca),
      _ => const Color(0xff5c281c),
    };
  }

  Color get red_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff000003),
      ColorTheme.DARK => const Color(0xe6000006),
      _ => const Color(0xff000003),
    };
  }

  Color get red_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff200008),
      ColorTheme.DARK => const Color(0xfe5a240e),
      _ => const Color(0xff200008),
    };
  }

  Color get red_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xf52b0018),
      ColorTheme.DARK => const Color(0xfe360b2a),
      _ => const Color(0xf52b0018),
    };
  }

  Color get red_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff35002c),
      ColorTheme.DARK => const Color(0xfd240042),
      _ => const Color(0xff35002c),
    };
  }

  Color get red_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff32003e),
      ColorTheme.DARK => const Color(0xfe360e53),
      _ => const Color(0xff32003e),
    };
  }

  Color get red_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xf9300051),
      ColorTheme.DARK => const Color(0xfe522e63),
      _ => const Color(0xf9300051),
    };
  }

  Color get red_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xe72d0068),
      ColorTheme.DARK => const Color(0xfd67467d),
      _ => const Color(0xe72d0068),
    };
  }

  Color get red_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xdb290085),
      ColorTheme.DARK => const Color(0xfe6d4ea7),
      _ => const Color(0xdb290085),
    };
  }

  Color get red_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xdf2600d1),
      ColorTheme.DARK => const Color(0xfe5431e4),
      _ => const Color(0xdf2600d1),
    };
  }

  Color get red_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xd22400e2),
      ColorTheme.DARK => const Color(0xfe4722d4),
      _ => const Color(0xd22400e2),
    };
  }

  Color get red_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xcb2400e9),
      ColorTheme.DARK => const Color(0xffff9277),
      _ => const Color(0xcb2400e9),
    };
  }

  Color get red_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x480e00e3),
      ColorTheme.DARK => const Color(0xffd6cdfb),
      _ => const Color(0x480e00e3),
    };
  }

  Color get yellow_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffefdfb),
      ColorTheme.DARK => const Color(0xff13110c),
      _ => const Color(0xfffefdfb),
    };
  }

  Color get yellow_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffffaea),
      ColorTheme.DARK => const Color(0xff1c1810),
      _ => const Color(0xfffffaea),
    };
  }

  Color get yellow_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffff2c3),
      ColorTheme.DARK => const Color(0xff2c220c),
      _ => const Color(0xfffff2c3),
    };
  }

  Color get yellow_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffffe9a0),
      ColorTheme.DARK => const Color(0xff3b2900),
      _ => const Color(0xffffe9a0),
    };
  }

  Color get yellow_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffffde7f),
      ColorTheme.DARK => const Color(0xff483300),
      _ => const Color(0xffffde7f),
    };
  }

  Color get yellow_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffcd27a),
      ColorTheme.DARK => const Color(0xff554112),
      _ => const Color(0xfffcd27a),
    };
  }

  Color get yellow_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe9c16e),
      ColorTheme.DARK => const Color(0xff695323),
      _ => const Color(0xffe9c16e),
    };
  }

  Color get yellow_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffd7a944),
      ColorTheme.DARK => const Color(0xff84692e),
      _ => const Color(0xffd7a944),
    };
  }

  Color get yellow_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffffca2f),
      ColorTheme.DARK => const Color(0xffffc53d),
      _ => const Color(0xffffca2f),
    };
  }

  Color get yellow_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffac137),
      ColorTheme.DARK => const Color(0xfff4bb2e),
      _ => const Color(0xfffac137),
    };
  }

  Color get yellow_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff9b6f00),
      ColorTheme.DARK => const Color(0xffffcc4c),
      _ => const Color(0xff9b6f00),
    };
  }

  Color get yellow_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff463a20),
      ColorTheme.DARK => const Color(0xfffee7ba),
      _ => const Color(0xff463a20),
    };
  }

  Color get yellow_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xc0800004),
      ColorTheme.DARK => const Color(0xbb110003),
      _ => const Color(0xc0800004),
    };
  }

  Color get yellow_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffc30015),
      ColorTheme.DARK => const Color(0xfba6000c),
      _ => const Color(0xffc30015),
    };
  }

  Color get yellow_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffc8003c),
      ColorTheme.DARK => const Color(0xffa7001d),
      _ => const Color(0xffc8003c),
    };
  }

  Color get yellow_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffc4005f),
      ColorTheme.DARK => const Color(0xff99002d),
      _ => const Color(0xffc4005f),
    };
  }

  Color get yellow_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffbe0080),
      ColorTheme.DARK => const Color(0xffa4003b),
      _ => const Color(0xffbe0080),
    };
  }

  Color get yellow_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfaa90085),
      ColorTheme.DARK => const Color(0xffb91549),
      _ => const Color(0xfaa90085),
    };
  }

  Color get yellow_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xd9920091),
      ColorTheme.DARK => const Color(0xfdc2415f),
      _ => const Color(0xd9920091),
    };
  }

  Color get yellow_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xc98a00bb),
      ColorTheme.DARK => const Color(0xfdc64d7c),
      _ => const Color(0xc98a00bb),
    };
  }

  Color get yellow_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffbe00d0),
      ColorTheme.DARK => const Color(0xffffc53d),
      _ => const Color(0xffbe00d0),
    };
  }

  Color get yellow_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xf9b000c8),
      ColorTheme.DARK => const Color(0xfec22ff4),
      _ => const Color(0xf9b000c8),
    };
  }

  Color get yellow_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff9b6f00),
      ColorTheme.DARK => const Color(0xffffcc4c),
      _ => const Color(0xff9b6f00),
    };
  }

  Color get yellow_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x2c1e00df),
      ColorTheme.DARK => const Color(0xffe8bbfe),
      _ => const Color(0x2c1e00df),
    };
  }

  Color get green_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffbfefb),
      ColorTheme.DARK => const Color(0xff0d130e),
      _ => const Color(0xfffbfefb),
    };
  }

  Color get green_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfff5fbf6),
      ColorTheme.DARK => const Color(0xff141a14),
      _ => const Color(0xfff5fbf6),
    };
  }

  Color get green_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe8f7e9),
      ColorTheme.DARK => const Color(0xff1c2a1d),
      _ => const Color(0xffe8f7e9),
    };
  }

  Color get green_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffdaf0db),
      ColorTheme.DARK => const Color(0xff1f3a23),
      _ => const Color(0xffdaf0db),
    };
  }

  Color get green_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffc8e9cb),
      ColorTheme.DARK => const Color(0xff27482b),
      _ => const Color(0xffc8e9cb),
    };
  }

  Color get green_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffb2deb6),
      ColorTheme.DARK => const Color(0xff2f5735),
      _ => const Color(0xffb2deb6),
    };
  }

  Color get green_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff94ce9a),
      ColorTheme.DARK => const Color(0xff37673e),
      _ => const Color(0xff94ce9a),
    };
  }

  Color get green_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff67b973),
      ColorTheme.DARK => const Color(0xff407948),
      _ => const Color(0xff67b973),
    };
  }

  Color get green_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff46a758),
      ColorTheme.DARK => const Color(0xff46a758),
      _ => const Color(0xff46a758),
    };
  }

  Color get green_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff3d9a4f),
      ColorTheme.DARK => const Color(0xff389a4c),
      _ => const Color(0xff3d9a4f),
    };
  }

  Color get green_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff297e3b),
      ColorTheme.DARK => const Color(0xff73d081),
      _ => const Color(0xff297e3b),
    };
  }

  Color get green_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff213c24),
      ColorTheme.DARK => const Color(0xffc0f0c4),
      _ => const Color(0xff213c24),
    };
  }

  Color get green_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00c00004),
      ColorTheme.DARK => const Color(0x00bb0003),
      _ => const Color(0x00c00004),
    };
  }

  Color get green_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00991a0a),
      ColorTheme.DARK => const Color(0x5ef75e0a),
      _ => const Color(0x00991a0a),
    };
  }

  Color get green_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00a70c17),
      ColorTheme.DARK => const Color(0x79fe831b),
      _ => const Color(0x00a70c17),
    };
  }

  Color get green_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00980725),
      ColorTheme.DARK => const Color(0x63ff7a2c),
      _ => const Color(0x00980725),
    };
  }

  Color get green_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00990e37),
      ColorTheme.DARK => const Color(0x71ff823b),
      _ => const Color(0x00990e37),
    };
  }

  Color get green_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x00920e4d),
      ColorTheme.DARK => const Color(0x77ff8c4b),
      _ => const Color(0x00920e4d),
    };
  }

  Color get green_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x018b0f6b),
      ColorTheme.DARK => const Color(0x7afd8d5d),
      _ => const Color(0x018b0f6b),
    };
  }

  Color get green_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x008a1498),
      ColorTheme.DARK => const Color(0x7cfd8e70),
      _ => const Color(0x008a1498),
    };
  }

  Color get green_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x008619b9),
      ColorTheme.DARK => const Color(0x65ff82a1),
      _ => const Color(0x008619b9),
    };
  }

  Color get green_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x007a18c2),
      ColorTheme.DARK => const Color(0x55ff7893),
      _ => const Color(0x007a18c2),
    };
  }

  Color get green_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x006516d6),
      ColorTheme.DARK => const Color(0x8bff9dcd),
      _ => const Color(0x006516d6),
    };
  }

  Color get green_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x001f04de),
      ColorTheme.DARK => const Color(0xccffd0ef),
      _ => const Color(0x001f04de),
    };
  }

  Color get blue_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfffbfdff),
      ColorTheme.DARK => const Color(0xff08121c),
      _ => const Color(0xfffbfdff),
    };
  }

  Color get blue_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xfff4faff),
      ColorTheme.DARK => const Color(0xff0e1926),
      _ => const Color(0xfff4faff),
    };
  }

  Color get blue_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffe9f3ff),
      ColorTheme.DARK => const Color(0xff0a2847),
      _ => const Color(0xffe9f3ff),
    };
  }

  Color get blue_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffd9edff),
      ColorTheme.DARK => const Color(0xff003262),
      _ => const Color(0xffd9edff),
    };
  }

  Color get blue_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffc7e3ff),
      ColorTheme.DARK => const Color(0xff003f75),
      _ => const Color(0xffc7e3ff),
    };
  }

  Color get blue_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xffb2d6ff),
      ColorTheme.DARK => const Color(0xff104d86),
      _ => const Color(0xffb2d6ff),
    };
  }

  Color get blue_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff97c5f9),
      ColorTheme.DARK => const Color(0xff1d5e9d),
      _ => const Color(0xff97c5f9),
    };
  }

  Color get blue_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff6eadf3),
      ColorTheme.DARK => const Color(0xff2371bd),
      _ => const Color(0xff6eadf3),
    };
  }

  Color get blue_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0090ff),
      ColorTheme.DARK => const Color(0xff0090ff),
      _ => const Color(0xff0090ff),
    };
  }

  Color get blue_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0084ec),
      ColorTheme.DARK => const Color(0xff0083f1),
      _ => const Color(0xff0084ec),
    };
  }

  Color get blue_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0073dd),
      ColorTheme.DARK => const Color(0xff70b8ff),
      _ => const Color(0xff0073dd),
    };
  }

  Color get blue_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff003463),
      ColorTheme.DARK => const Color(0xffc8e3ff),
      _ => const Color(0xff003463),
    };
  }

  Color get blue_alpha_1 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0080ff04),
      ColorTheme.DARK => const Color(0x0027fb0c),
      _ => const Color(0x0080ff04),
    };
  }

  Color get blue_alpha_2 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x008cff0b),
      ColorTheme.DARK => const Color(0x006afa17),
      _ => const Color(0x008cff0b),
    };
  }

  Color get blue_alpha_3 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0074ff16),
      ColorTheme.DARK => const Color(0x0077ff3a),
      _ => const Color(0x0074ff16),
    };
  }

  Color get blue_alpha_4 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0087ff26),
      ColorTheme.DARK => const Color(0x0072ff57),
      _ => const Color(0x0087ff26),
    };
  }

  Color get blue_alpha_5 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0080ff38),
      ColorTheme.DARK => const Color(0x007efd6c),
      _ => const Color(0x0080ff38),
    };
  }

  Color get blue_alpha_6 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0078ff4d),
      ColorTheme.DARK => const Color(0x0f8afd7e),
      _ => const Color(0x0078ff4d),
    };
  }

  Color get blue_alpha_7 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x0071f168),
      ColorTheme.DARK => const Color(0x2694ff96),
      _ => const Color(0x0071f168),
    };
  }

  Color get blue_alpha_8 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0x006fea91),
      ColorTheme.DARK => const Color(0x2a95feb9),
      _ => const Color(0x006fea91),
    };
  }

  Color get blue_alpha_9 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0090ff),
      ColorTheme.DARK => const Color(0xff0090ff),
      _ => const Color(0xff0090ff),
    };
  }

  Color get blue_alpha_10 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0084ec),
      ColorTheme.DARK => const Color(0x008afff0),
      _ => const Color(0xff0084ec),
    };
  }

  Color get blue_alpha_11 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff0073dd),
      ColorTheme.DARK => const Color(0xff70b8ff),
      _ => const Color(0xff0073dd),
    };
  }

  Color get blue_alpha_12 {
    return switch (_ct) {
      ColorTheme.LIGHT => const Color(0xff003463),
      ColorTheme.DARK => const Color(0xffc8e3ff),
      _ => const Color(0xff003463),
    };
  }
}

class _FontRes {
  var base = const TextStyle(color: Colors.black);

  TextStyle get title => base.copyWith(fontSize: 20);

  TextStyle get subtitle => base.copyWith(fontSize: 18);
}

enum Language { CN }

class _StringRes {
  Language _language;

  _StringRes(this._language);
}
