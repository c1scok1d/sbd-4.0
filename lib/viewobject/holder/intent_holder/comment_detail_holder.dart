import 'package:flutter/cupertino.dart';
import 'package:businesslistingapi/viewobject/comment_header.dart';

class CommentDetailHolder {
  const CommentDetailHolder({
    @required this.cityId,
    @required this.commentHeader,
  });
  final String cityId;
  final CommentHeader commentHeader;
}
