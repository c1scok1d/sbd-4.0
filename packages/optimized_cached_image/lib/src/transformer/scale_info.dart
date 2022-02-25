import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ScaleInfo {
  final File file;
  final int width;
  final int height;
  final CompressFormat compressFormat;

  // ignore: sort_constructors_first
  const ScaleInfo(this.file, this.width, this.height, this.compressFormat);
}
