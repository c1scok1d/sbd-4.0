import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.clickSearchButton});

  final TextEditingController textEditingController;
  final String hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder psValueHolder;
  final Function clickEnterFunction;
  final Function clickSearchButton;

  @override
  Widget build(BuildContext context) {
    final ItemParameterHolder itemParameterHolder =
        ItemParameterHolder().getLatestParameterHolder();
    final Widget _productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space12,
          bottom: PsDimens.space8,
          top: PsDimens.space10,
        ),
        border: InputBorder.none,
        hintText: hintText,
        suffixIcon: InkWell(
            child: const Icon(
              Icons.search,
            ),
            onTap: () {
              //clickSearchButton();
              itemParameterHolder.keyword = textEditingController.text;
              Navigator.pushNamed(context, RoutePaths.filterItemList,
                  arguments: ItemListIntentHolder(
                    checkPage: '0',
                    appBarTitle: textEditingController.text,
                    itemParameterHolder: itemParameterHolder,
                  ));
            }),
      ),
      onSubmitted: (String value) {
        // clickEnterFunction();
        itemParameterHolder.keyword = textEditingController.text;
        Navigator.pushNamed(context, RoutePaths.filterItemList,
            arguments: ItemListIntentHolder(
              checkPage: '0',
              appBarTitle: textEditingController.text,
              itemParameterHolder: itemParameterHolder,
            ));
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? PsColors.white : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space8),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
