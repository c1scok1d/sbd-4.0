import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/ps_expansion_tile.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item_spec.dart';

class WhatYouGetTileView extends StatefulWidget {
  const WhatYouGetTileView({Key key, @required this.itemSpecList})
      : super(key: key);
  final List<ItemSpecification> itemSpecList;

  @override
  _WhatYouGetTileViewState createState() => _WhatYouGetTileViewState();
}

class _WhatYouGetTileViewState extends State<WhatYouGetTileView> {
  @override
  Widget build(BuildContext context) {
    return _WhatYouGetTilewidget(itemSpecList: widget.itemSpecList);
  }
}

class _WhatYouGetTilewidget extends StatelessWidget {
  const _WhatYouGetTilewidget({this.itemSpecList});
  final List<ItemSpecification> itemSpecList;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'what_you_get_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileIconWidget = Icon(
      MaterialCommunityIcons.paperclip,
      color: PsColors.mainColor,
    );

    if (itemSpecList != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          border: Border.all(color: PsColors.grey, width: 0.3),
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          leading: _expansionTileIconWidget,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Column(
              children: <Widget>[
                Divider(
                  height: PsDimens.space1,
                  color: Theme.of(context).iconTheme.color,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space16, right: PsDimens.space16),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemSpecList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _SpecificationTextWidget(
                          specification: itemSpecList[index],
                        );
                      }),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _SpecificationTextWidget extends StatelessWidget {
  const _SpecificationTextWidget({
    Key key,
    @required this.specification,
  }) : super(key: key);

  final ItemSpecification specification;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(
            top: PsDimens.space4, bottom: PsDimens.space8),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                specification.name,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space32,
                  ),
                  Text(specification.description,
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
          ],
        ));
  }
}
