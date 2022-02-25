import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/ui/common/ps_expansion_tile.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/terms_and_condition_intent_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';

class TermsAndPolicyTileView extends StatelessWidget {
  const TermsAndPolicyTileView(
      {Key key,
      @required this.itemData,
      @required this.checkPolicyType,
      @required this.title})
      : super(key: key);

  final Item itemData;
  final int checkPolicyType;
  final String title;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget =
        Text(title, style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget = Icon(
      checkPolicyType == 4
          ? MaterialCommunityIcons.lightbulb_on_outline
          : EvilIcons.exclamation,
      color: PsColors.mainColor,
    );
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        border: Border.all(color: PsColors.grey, width: 0.3),
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileLeadingIconWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              Padding(
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Text(
                    checkPolicyType == 1
                        ? itemData.terms
                        : checkPolicyType == 2
                            ? itemData.cancelationPolicy
                            : checkPolicyType == 3
                                ? itemData.additionalInfo
                                : checkPolicyType == 4
                                    ? itemData.highlightInformation
                                    : '',
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              if (checkPolicyType == 4)
                Container()
              else
                Container(
                  margin: const EdgeInsets.only(bottom: PsDimens.space16),
                  padding: const EdgeInsets.all(PsDimens.space12),
                  child: InkWell(
                    onTap: () {
                      String description = '';
                      if (checkPolicyType == 1) {
                        description = itemData.terms;
                      } else if (checkPolicyType == 2) {
                        description = itemData.cancelationPolicy;
                      } else if (checkPolicyType == 3) {
                        description = itemData.additionalInfo;
                      } else {
                        description = '';
                      }
                      Navigator.pushNamed(
                        context,
                        RoutePaths.termsAndCondition,
                        arguments: TermsAndConditionIntentHolder(
                          checkType: checkPolicyType,
                          description: description,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Utils.getString(context, 'item_detail__read_more'),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: PsColors.mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
