import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/item/item_provider.dart';
import 'package:businesslistingapi/ui/common/ps_expansion_tile.dart';
import 'package:businesslistingapi/ui/items/item/related_tags_horizontal_list_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/tag_object_holder.dart';
import 'package:flutter/material.dart';

class RelatedTagsTileView extends StatefulWidget {
  const RelatedTagsTileView({
    Key key,
    @required this.itemDetail,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;

  @override
  _RelatedTagsTileViewState createState() => _RelatedTagsTileViewState();
}

class _RelatedTagsTileViewState extends State<RelatedTagsTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'tag_tile__title'),
        style: Theme.of(context).textTheme.subtitle1.copyWith());

    final List<String> tags =
        widget.itemDetail.itemDetail.data.searchTag.split(',');

    final List<TagParameterHolder> tagObjectList = <TagParameterHolder>[
      TagParameterHolder(
          fieldName: PsConst.CONST_CATEGORY,
          tagId: widget.itemDetail.itemDetail.data.category.id,
          tagName: widget.itemDetail.itemDetail.data.category.name),
      TagParameterHolder(
          fieldName: PsConst.CONST_SUB_CATEGORY,
          tagId: widget.itemDetail.itemDetail.data.subCategory.id,
          tagName: widget.itemDetail.itemDetail.data.subCategory.name),
      for (String tag in tags)
        if (tag != null && tag != '')
          TagParameterHolder(
              fieldName: PsConst.CONST_PRODUCT, tagId: tag, tagName: tag),
    ];

    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        border: Border.all(color: PsColors.grey, width: 0.3),
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(
                height: PsDimens.space1,
                color: Theme.of(context).iconTheme.color,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: PsDimens.space16,
                    bottom: PsDimens.space16,
                    left: PsDimens.space16,
                    right: PsDimens.space16),
                child: _RelatedTagsWidget(
                  tagObjectList: tagObjectList,
                  itemDetailProvider: widget.itemDetail,
                ),
              ),
              // const _RelatedItemWidget()
            ],
          )
        ],
        onExpansionChanged: (bool expanding) {},
      ),
    );
  }
}

class _RelatedTagsWidget extends StatelessWidget {
  const _RelatedTagsWidget({
    Key key,
    @required this.tagObjectList,
    @required this.itemDetailProvider,
  }) : super(key: key);

  final List<TagParameterHolder> tagObjectList;
  final ItemDetailProvider itemDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PsDimens.space40,
      child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (tagObjectList != null) {
                  return RelatedTagsHorizontalListItem(
                    tagParameterHolder: tagObjectList[index],
                    onTap: () async {
                      final ItemParameterHolder itemParameterHolder =
                          ItemParameterHolder().resetParameterHolder();

                      if (index == 0) {
                        itemParameterHolder.catId =
                            itemDetailProvider.itemDetail.data.catId;
                      } else if (index == 1) {
                        itemParameterHolder.catId =
                            itemDetailProvider.itemDetail.data.catId;
                        itemParameterHolder.subCatId =
                            itemDetailProvider.itemDetail.data.subCatId;
                      } else {
                        itemParameterHolder.keyword =
                            tagObjectList[index].tagName;
                      }
                      print('itemParameterHolder.catId ' +
                          itemParameterHolder.catId +
                          'itemParameterHolder.subCatId ' +
                          itemParameterHolder.subCatId +
                          'itemParameterHolder.searchTerm ' +
                          itemParameterHolder.keyword);
                      Navigator.pushNamed(context, RoutePaths.filterItemList,
                          arguments: ItemListIntentHolder(
                            checkPage: '0',
                            appBarTitle: tagObjectList[index].tagName,
                            itemParameterHolder: itemParameterHolder,
                          ));
                    },
                  );
                } else {
                  return null;
                }
              }, childCount: tagObjectList.length),
            ),
          ]),
    );
  }
}

// class _RelatedItemWidget extends StatelessWidget {
//   const _RelatedItemWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RelatedItemProvider>(
//       builder:
//           (BuildContext context, RelatedItemProvider provider, Widget child) {
//         if (provider.relatedItemList != null &&
//             provider.relatedItemList.data != null &&
//             provider.relatedItemList.data.isNotEmpty) {
//           return Container(
//             height: PsDimens.space300,
//             color: PsColors.coreBackgroundColor,
//             child: CustomScrollView(
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 slivers: <Widget>[
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (BuildContext context, int index) {
//                         if (provider.relatedItemList.data != null ||
//                             provider.relatedItemList.data.isNotEmpty) {
//                           return ItemHorizontalListItem(
//                             coreTagKey: provider.hashCode.toString() +
//                                 provider.relatedItemList.data[index].id,
//                             item: provider.relatedItemList.data[index],
//                             onTap: () {
//                               final Item relatedItem =
//                                   provider.relatedItemList.data[index];
//                               final ItemDetailIntentHolder holder =
//                                   ItemDetailIntentHolder(
//                                 item: relatedItem,
//                                 heroTagImage: provider.hashCode.toString() +
//                                     relatedItem.id +
//                                     PsConst.HERO_TAG__IMAGE,
//                                 heroTagTitle: provider.hashCode.toString() +
//                                     relatedItem.id +
//                                     PsConst.HERO_TAG__TITLE,
//                                 heroTagOriginalPrice:
//                                     provider.hashCode.toString() +
//                                         relatedItem.id +
//                                         PsConst.HERO_TAG__ORIGINAL_PRICE,
//                                 heroTagUnitPrice: provider.hashCode.toString() +
//                                     relatedItem.id +
//                                     PsConst.HERO_TAG__UNIT_PRICE,
//                               );

//                               Navigator.pushNamed(
//                                   context, RoutePaths.itemDetail,
//                                   arguments: holder);
//                             },
//                           );
//                         } else {
//                           return null;
//                         }
//                       },
//                       childCount: provider.relatedItemList.data.length,
//                     ),
//                   ),
//                 ]),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
