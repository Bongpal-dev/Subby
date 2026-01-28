import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Figma 디자인 시스템 아이콘
enum AppIconType {
  back('ic_back'),
  calendar('ic_calendar'),
  check('ic_check'),
  download('ic_download'),
  dropdown('ic_dropdown'),
  group('ic_group'),
  home('ic_home'),
  menu('ic_menu'),
  more('ic_more'),
  my('ic_my'),
  next('ic_next'),
  plus('ic_plus'),
  plusSmall('ic_plus_small'),
  search('ic_search'),
  setting('ic_setting'),
  static_('ic_static'),
  trash('ic_trash'),
  xSmall('ic_x_small'),
  xmark('ic_xmark');

  const AppIconType(this.fileName);
  final String fileName;

  String get path => 'assets/icons/$fileName.svg';
}

/// SVG 아이콘 위젯
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
  });

  final AppIconType icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.path,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
