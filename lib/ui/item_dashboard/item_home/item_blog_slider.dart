import 'package:carousel_slider/carousel_slider.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/blog.dart';

class ItemBlogSliderView extends StatefulWidget {
  const ItemBlogSliderView({
    Key key,
    @required this.blogList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<Blog> blogList;

  @override
  _CollectionItemSliderState createState() => _CollectionItemSliderState();
}

class _CollectionItemSliderState extends State<ItemBlogSliderView> {
  String _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.blogList != null && widget.blogList.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
                // enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 1,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (int i, CarouselPageChangedReason reason) {
                  setState(() {
                    _currentId = widget.blogList[i].id;
                  });
                }),

            items: widget.blogList.map((Blog blog) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PsColors.mainLightShadowColor,
                  ),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PsColors.mainLightShadowColor,
                        offset: const Offset(1.1, 1.1),
                        blurRadius: PsDimens.space8),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(PsDimens.space8),
                      child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: blog.defaultPhoto,
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          onTap: () {
                            widget.onTap(blog);
                          }),
                    ),
                  ],
                ),
              );
            }).toList(),
            // onPageChanged: (int i) {
            //   setState(() {
            //     _currentId = widget.blogList[i].id;
            //   });
            // },
          )
        else
          Container(),
        Positioned(
            bottom: 5.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.blogList != null && widget.blogList.isNotEmpty
                  ? widget.blogList.map((Blog blog) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == blog.id
                                    ? PsColors.mainColor
                                    : PsColors.grey));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
