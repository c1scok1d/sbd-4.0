import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem(
      {Key key,
      @required this.blog,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Blog blog;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: Container(
                color: PsColors.backgroundColor,
                margin: const EdgeInsets.all(PsDimens.space8),
                child: BlogListItemWidget(blog: blog))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child,
              ));
        });
  }
}

class BlogListItemWidget extends StatelessWidget {
  const BlogListItemWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space4),
          child: PsNetworkImage(
            height: PsDimens.space200,
            width: double.infinity,
            photoKey: blog.id,
            defaultPhoto: blog.defaultPhoto,
            boxfit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space12),
          child: Text(
            blog.name,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space4,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            blog.description,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(
                top: PsDimens.space4,
                bottom: PsDimens.space12,
                left: PsDimens.space8,
                right: PsDimens.space8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    child: PsNetworkImage(
                      height: PsDimens.space60,
                      width: PsDimens.space60,
                      photoKey: '${blog.id} ${blog.city.id}',
                      defaultPhoto: blog.defaultPhoto,
                      boxfit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: PsDimens.space12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      blog.city.name,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: PsDimens.space8),
                    Text(
                      blog.addedDateStr,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
