import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Figma 디자인 시스템 로고
enum AppLogoType {
  /// 기본 플레이스홀더 로고
  placeholder('logo_default'),

  /// 추후 추가될 서비스 로고들
  // youtube('logo_youtube'),
  // claude('logo_claude'),
  // netflix('logo_netflix'),
  // subby('logo_subby'),
  ;

  const AppLogoType(this.fileName);
  final String fileName;

  String get path => 'assets/icons/$fileName.svg';
}

/// 서비스 로고 위젯
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.type = AppLogoType.placeholder,
    this.size = 48,
    this.borderRadius = 12,
  });

  final AppLogoType type;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SvgPicture.asset(
        type.path,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
