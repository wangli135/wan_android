import 'package:flutter/widgets.dart';

class AliIcons {
  static const IconData wechat = const _AliIconData(0xe679);
}

class _AliIconData extends IconData {
  const _AliIconData(int codePoint)
      : super(codePoint, fontFamily: 'AliIcon');
}
