import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/gallery/gallery_provider.dart';
import 'package:businesslistingapi/repository/gallery_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/ui/gallery/item/gallery_grid_item.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/ps_ui_widget.dart';

class GalleryGridView extends StatefulWidget {
  const GalleryGridView({
    Key key,
    @required this.product,
    this.onImageTap,
  }) : super(key: key);

  final Item product;
  final Function onImageTap;
  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository productRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
        initProvider: () {
          return GalleryProvider(repo: productRepo);
        },
        onProviderReady: (GalleryProvider provider) {
          provider.loadImageList(
            widget.product.defaultPhoto.imgParentId,
          );
        },
        builder:
            (BuildContext context, GalleryProvider provider, Widget child) {
          if (provider.galleryList != null &&
              provider.galleryList.data.isNotEmpty) {
            return Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).cardColor,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RefreshIndicator(
                      onRefresh: () {
                        return provider.refreshImageList(
                            widget.product.defaultPhoto.imgParentId);
                      },
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150,
                                      childAspectRatio: 1.0),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return GalleryGridItem(
                                      image: provider.galleryList.data[index],
                                      onImageTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryDetail,
                                            arguments:
                                                provider.galleryList.data[index]);
                                      });
                                },
                                childCount: provider.galleryList.data.length,
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
                PSProgressIndicator(provider.galleryList.status)
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
