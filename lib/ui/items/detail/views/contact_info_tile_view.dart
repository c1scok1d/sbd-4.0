import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/provider/item/item_provider.dart';
import 'package:businesslistingapi/ui/common/ps_expansion_tile.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoTileView extends StatelessWidget {
  const ContactInfoTileView({
    Key key,
    @required this.itemDetail,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'contact_info__contact_info'),
        style: Theme.of(context).textTheme.subtitle1);
    if (itemDetail != null &&
        itemDetail.itemDetail != null &&
        itemDetail.itemDetail.data != null) {
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
          leading: Icon(Icons.timer, color: PsColors.mainColor),
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  _OpeningHourWidget(
                    data: itemDetail.itemDetail.data,
                  ),
                  if (itemDetail.itemDetail.data.phone1 != '' &&
                      itemDetail.itemDetail.data.phone2 != '' &&
                      itemDetail.itemDetail.data.phone3 != '')
                    _PhoneAndContactWidget(
                      phoneData: itemDetail.itemDetail.data,
                    )
                  else
                    Container(),
                  _LinkAndTitle(
                      icon: FontAwesome.wordpress,
                      title: Utils.getString(
                          context, 'contact_info__visit_our_website'),
                      link: itemDetail.itemDetail.data.website),
                  _LinkAndTitle(
                      icon: FontAwesome.facebook,
                      title: Utils.getString(context, 'contact_info__facebook'),
                      link: itemDetail.itemDetail.data.facebook),
                  _LinkAndTitle(
                      icon: FontAwesome.google_plus_circle,
                      title:
                          Utils.getString(context, 'contact_info__google_plus'),
                      link: itemDetail.itemDetail.data.googlePlus),
                  _LinkAndTitle(
                      icon: FontAwesome.twitter_square,
                      title: Utils.getString(context, 'contact_info__twitter'),
                      link: itemDetail.itemDetail.data.twitter),
                  _LinkAndTitle(
                      icon: FontAwesome.instagram,
                      title:
                          Utils.getString(context, 'contact_info__instagram'),
                      link: itemDetail.itemDetail.data.instagram),
                  _LinkAndTitle(
                      icon: FontAwesome.youtube,
                      title: Utils.getString(context, 'contact_info__youtube'),
                      link: itemDetail.itemDetail.data.youtube),
                  _LinkAndTitle(
                      icon: FontAwesome.pinterest,
                      title:
                          Utils.getString(context, 'contact_info__pinterest'),
                      link: itemDetail.itemDetail.data.pinterest),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _OpeningHourWidget extends StatelessWidget {
  const _OpeningHourWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Item data;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );
    return Container(
      color: PsColors.backgroundColor,
      margin: const EdgeInsets.only(top: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: PsDimens.space20,
              height: PsDimens.space20,
              child: const Icon(
                Icons.timer,
              )),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'contact_info__opening_hour'),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  _spacingWidget,
                  Text(
                    '${data.openingHour} - ${data.closingHour}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  _spacingWidget,
                  Text(
                    '${Utils.getString(context, 'contact_info__remark')} ${data.timeRemark}',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                  _spacingWidget,
                ],
              ),
            ),
          ),
        ],
      ),
      //     _spacingWidget,
      //   ],
      // )
    );
  }
}

class _PhoneAndContactWidget extends StatelessWidget {
  const _PhoneAndContactWidget({
    Key key,
    @required this.phoneData,
  }) : super(key: key);

  final Item phoneData;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );
    return Container(
      color: PsColors.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: PsDimens.space20,
              height: PsDimens.space20,
              child: const Icon(
                Icons.phone_in_talk,
              )),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'contact_info__phone'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                _spacingWidget,
                _PhoneWidget(phoneNumber: phoneData.phone1),
                _spacingWidget,
                _PhoneWidget(phoneNumber: phoneData.phone2),
                _spacingWidget,
                _PhoneWidget(phoneNumber: phoneData.phone3),
              ],
            ),
          ),
        ],
      ),
      //     _spacingWidget,
      //   ],
      // )
    );
  }
}

class _PhoneWidget extends StatelessWidget {
  const _PhoneWidget({Key key, @required this.phoneNumber}) : super(key: key);
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            phoneNumber,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'Call',
            // Utils.getString(context, 'contact_info_tile__call'),
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.green),
          ),
        ],
      ),
      onTap: () async {
        if (await canLaunch('tel://$phoneNumber')) {
          await launch('tel://$phoneNumber');
        } else {
          throw 'Could not Call Phone Number 3';
        }
      },
    );
  }
}

class _LinkAndTitle extends StatelessWidget {
  const _LinkAndTitle({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.link,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(
            top: PsDimens.space16, bottom: PsDimens.space12),
        // padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                      width: PsDimens.space20,
                      height: PsDimens.space20,
                      child: Icon(
                        icon,
                      )),
                  const SizedBox(
                    width: PsDimens.space12,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
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
                  InkWell(
                    child: Text(
                        link == ''
                            ? Utils.getString(context, 'contact_info__dash')
                            : link,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.mainColor)),
                    onTap: () async {
                      if (await canLaunch(link)) {
                        await launch(link);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'invalid url',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: PsColors.mainColor,
                            textColor: PsColors.white);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
