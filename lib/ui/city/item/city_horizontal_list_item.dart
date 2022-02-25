import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CityHorizontalListItem extends StatelessWidget {
  const CityHorizontalListItem({
    Key key,
    @required this.city,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final City city;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space4, vertical: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.transparent,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space12)),
          ),
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(PsDimens.space8)),
                  ),
                  child: ClipPath(
                    child: PsNetworkImage(
                      photoKey: '',
                      defaultPhoto: city.defaultPhoto,
                      width: double.infinity,
                      //height: double.infinity,
                      boxfit: BoxFit.cover,
                      onTap: () {
                        Utils.psPrint(city.defaultPhoto.imgParentId);
                        onTap();
                      },
                    ),
                    clipper: const ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(PsDimens.space8)))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: PsDimens.space10,
                  top: PsDimens.space12,
                  right: PsDimens.space8,
                ),
                child: Text(
                  city.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space8,
                    top: PsDimens.space12,
                    right: PsDimens.space8,
                    bottom: PsDimens.space4),
                child: Text(
                  city.description,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ));
  }
}
