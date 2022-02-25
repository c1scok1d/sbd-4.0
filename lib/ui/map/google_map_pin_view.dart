import 'dart:io';

import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:businesslistingapi/ui/common/smooth_star_rating_widget.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/city.dart';
import 'package:businesslistingapi/viewobject/holder/google_map_pin_call_back_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapPinView extends StatefulWidget {
  const GoogleMapPinView(
      {@required this.flag,
      @required this.maplat,
      @required this.maplng,
      this.city,
      this.item});

  final String flag;
  final String maplat;
  final String maplng;
  final City city;
  final Item item;

  @override
  _MapPinViewState createState() => _MapPinViewState();
}

class _MapPinViewState extends State<GoogleMapPinView>
    with TickerProviderStateMixin {
  LatLng latlng;
 // double defaultRadius = 3000;
  String address = '';
  CameraPosition kGooglePlex;
  GoogleMapController mapController;
  bool showPin = true;

  dynamic loadAddress() async {
    final List<Address> addresses = await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(latlng.latitude, latlng.longitude));
    final Address first = addresses.first;
    address = '${first.addressLine}  \n, ${first.countryName}';
  }

  @override
  Widget build(BuildContext context) {
    print('My Item:' + widget.item.toString());
    latlng ??= LatLng(double.parse(widget.maplat), double.parse(widget.maplng));

    const double value = 15.0;
    // 16 - log(scale) / log(2);
    kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.maplat), double.parse(widget.maplng)),
      zoom: value,
    );
    loadAddress();

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'location_tile__title'),
        actions: widget.flag == PsConst.PIN_MAP
            ? <Widget>[
                InkWell(
                  child: Ink(
                    child: Center(  
                      child: Text(
                        'PICKLOCATION',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColorWithWhite),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                        context,
                        GoogleMapPinCallBackHolder(
                            address: address, latLng: latlng));
                  },
                ),
                const SizedBox(
                  width: PsDimens.space16,
                ),
              ]
            : <Widget>[],
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                child: Flexible(
                  child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: kGooglePlex,
                      /*circles: <Circle>{}..add(Circle(
                          circleId: CircleId(address),
                          center: latlng,
                          radius: 200,
                          fillColor: Colors.blue.withOpacity(0.7),
                          strokeWidth: 3,
                          strokeColor: Colors.redAccent,
                        )),*/
                      markers: <Marker>{}..add(Marker(
                          markerId: MarkerId(address),
                          position: latlng,
                          // infoWindow: InfoWindow(title: '${widget.item.name}'),
                          onTap: () {
                            if(_showInfoWindow = false){
                              _showInfoWindow = true;
                            }
                            //print("info window on tap");
                            setState(() {
                              _showInfoWindow = true;
                            });
                          })),
                      onTap: (lat) {
                        print('tap on map');
                        setState(() {
                          _showInfoWindow = false;
                          // this.latlng = latlng;
                        });
                      }),
                ),
              ),
              FutureBuilder(
                future: _calculation,
                builder: (context, snapshot) {

                  return mapInfo();
                },)
              // mapInfo(),
            ],
          ),
        ));
  }
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );
  Widget mapInfo() {
    if (_showInfoWindow) {
      Item c = widget.item;
      print('Image Loading:${c.toString()}');
      print(
          'Image Loading:${PsConfig.ps_app_image_url}${c.defaultPhoto.imgPath}');

      return Container(
            margin: EdgeInsets.only(
              left: _leftMargin,
              top: _topMargin,
            ),
            width: 300,
            height: 300,
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: GestureDetector(
              onTap: () {
                showDialog<void>(context: context, builder: (context) {

                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              height: 60,
                              width: double.infinity,
                              padding: const EdgeInsets.all(PsDimens.space8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: PsColors.mainColor),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: PsDimens.space4),
                                  Icon(
                                    Icons.directions,
                                    color: PsColors.white,
                                  ),
                                  const SizedBox(width: PsDimens.space4),
                                  Text(
                                    'Directions',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: PsColors.white,
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: PsDimens.space20),
                          Container(
                            padding: const EdgeInsets.only(
                                left: PsDimens.space16,
                                right: PsDimens.space16,
                                top: PsDimens.space8,
                                bottom: PsDimens.space8),
                            child: Text(
                              'Do you want directions to ${c.name}?',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          const SizedBox(height: PsDimens.space20),
                          Divider(
                            thickness: 0.5,
                            height: 1,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          ButtonBar(
                            children: [
                              MaterialButton(
                                height: 50,
                                minWidth: 100,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  openMap(double.parse(widget.item.lat),
                                      double.parse(widget.item.lng));
                                },
                                child: Text(
                                  'Yes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: PsColors.mainColor),
                                ),
                              ),
                              MaterialButton(
                                height: 50,
                                minWidth: 100,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'No',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: PsColors.mainColor),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),
                  );
                },);
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Image.network(
                      // 'https://api.sablebusinessdirectory.com/uploads/received_10212466727970205.jpeg'
                      PsConfig.ps_app_image_url + c.defaultPhoto.imgPath,
                    ),
                  ),
                  Text(
                    '${c.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    child: Text(
                      '${c.description}',
                      style: TextStyle(color: Colors.black54
                        // fontWeight: FontWeight.bold
                      ),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 60,
                    width: 150,
                    child: _HeaderRatingWidget(
                      itemDetail: widget.item,
                    ),
                  ),
                ],
              ),
            ),
          );
    }
    return Container();
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
          msg: 'Maps Not available',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  bool _showInfoWindow = false;
  bool _tempHidden = false;
  double _leftMargin;
  double _topMargin;

  void updateInfoWindow(
    BuildContext context,
    GoogleMapController controller,
    LatLng location,
    double infoWindowWidth,
    double markerOffset,
  ) async {
    ScreenCoordinate screenCoordinate =
        await controller.getScreenCoordinate(location);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (infoWindowWidth / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio);
    if (left < 0 || top < 0) {
      _tempHidden = true;
    } else {
      _tempHidden = false;
      _leftMargin = left;
      _topMargin = top;
    }
    print('setting state');
    setState(() {
      _showInfoWindow = true;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    updateInfoWindow(
        context, mapController, latlng, 300, 200);
  }

  void _handleTap(LatLng latlng) {
    print('tap on map');
    setState(() {
      // _showInfoWindow=false;
      // this.latlng = latlng;
    });
  }

  void _doNothingTap(LatLng latlng) {}
}

class _HeaderRatingWidget extends StatefulWidget {
  const _HeaderRatingWidget({
    Key key,
    @required this.itemDetail,
  }) : super(key: key);

  final Item itemDetail;

  @override
  __HeaderRatingWidgetState createState() => __HeaderRatingWidgetState();
}

class __HeaderRatingWidgetState extends State<_HeaderRatingWidget> {
  @override
  Widget build(BuildContext context) {
    dynamic result;

    if (widget.itemDetail != null && widget.itemDetail.ratingDetail != null) {
      if (widget.itemDetail.overallRating == '0') {
        return Container();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SmoothStarRating(
              key: Key(widget.itemDetail.ratingDetail.totalRatingValue),
              rating:
                  double.parse(widget.itemDetail.ratingDetail.totalRatingValue),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: PsColors.ratingColor,
              borderColor: Utils.isLightMode(context)
                  ? PsColors.black.withAlpha(100)
                  : PsColors.white,
              onRated: (double v) async {},
              spacing: 0.0),
          const SizedBox(
            height: PsDimens.space10,
          ),
          GestureDetector(
              onTap: () async {
                // result = await Navigator.pushNamed(
                //     context, RoutePaths.ratingList,
                //     arguments: widget.itemDetail.id);
                //
                // if (result != null && result) {
                //   // // setState(() {
                //   // widget.itemDetail.loadItem(
                //   //     widget.itemDetail.itemDetail.data.id,
                //   //     widget.itemDetail.psValueHolder.loginUserId);
                //   // // });
                // }
              },
              child: (widget.itemDetail.overallRating != '0')
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.itemDetail.ratingDetail.totalRatingValue ?? '',
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          '${Utils.getString(context, 'item_detail__out_of_five_stars')}(' +
                              widget.itemDetail.ratingDetail.totalRatingCount +
                              ' ${Utils.getString(context, 'item_detail__reviews')})',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                        ),
                      ],
                    )
                  : Text(Utils.getString(context, 'item_detail__no_rating'))),
          const SizedBox(
            height: PsDimens.space10,
          ),
          // if (widget.itemDetail.itemDetail.data.isAvailable == '1')
          //   Text(
          //     Utils.getString(context, 'item_detail__in_stock'),
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyText2
          //         .copyWith(color: PsColors.mainDarkColor),
          //   )
          // else
          //   Container(),
        ],
      );
    } else {
      return Container();
    }
  }
}
