import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopularCityHorizontalListItem extends StatelessWidget {
  const PopularCityHorizontalListItem({
    Key key,
    @required this.city,
    this.onTap,
  }) : super(key: key);

  final City city;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 300,
          margin: const EdgeInsets.only(left: PsDimens.space16),
          // color: Colors.red,
          child: Stack(
            children: <Widget>[
              ClipPath(
                child: PsNetworkImage(
                  photoKey: '',
                  defaultPhoto: city.defaultPhoto,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  boxfit: BoxFit.cover,
                  onTap: () {
                    Utils.psPrint(city.defaultPhoto.imgParentId);
                    onTap();
                  },
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              Positioned(
                top: 100,
                right: 20,
                left: 32,
                child: Container(
                    height: PsDimens.space140,
                    padding: const EdgeInsets.all(
                      PsDimens.space12,
                    ),
                    decoration: BoxDecoration(
                        color: PsColors.backgroundColor,
                        borderRadius: BorderRadius.circular(PsDimens.space12),
                        border: Border.all(color: PsColors.grey, width: 0.3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          city.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                        ),
                        const SizedBox(height: PsDimens.space8),
                        Expanded(
                          child: Text(
                            city.description,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
