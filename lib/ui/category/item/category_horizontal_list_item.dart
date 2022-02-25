import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space4, right: PsDimens.space4),
            width: MediaQuery.of(context).size.width / 2,
            height: PsDimens.space100,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(4),
                //     child: Stack(
                //       children: <Widget>[
                //         PsNetworkImage(
                //           photoKey: '',
                //           defaultPhoto: category.defaultPhoto,
                //           // width: PsDimens.space100,
                //           height: double.infinity,
                //           boxfit: BoxFit.cover,
                //         ),
                //         Container(
                //           // width: PsDimens.space100,
                //           height: double.infinity,
                //           color: PsColors.black.withAlpha(110),
                //         )
                //       ],
                //     )),
                // Text(
                //   category.name,
                //   textAlign: TextAlign.start,
                //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                //       color: PsColors.white, fontWeight: FontWeight.bold),
                // ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: PsNetworkImage(
                            photoKey: '',
                            defaultPhoto: category.defaultPhoto,
                            width: double.infinity,
                            height: PsDimens.space100,
                            boxfit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 200,
                          height: PsDimens.space100,
                          color: PsColors.black.withAlpha(110),
                        )
                      ],
                    )),
                Text(
                  category.name,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: PsColors.white, fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
}
