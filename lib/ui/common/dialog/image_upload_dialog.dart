import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';

class ImageUploadDialog extends StatefulWidget {
  const ImageUploadDialog({this.message, this.onPressed});
  final String message;
  final Function onPressed;

  @override
  _ImageUploadDialogState createState() => _ImageUploadDialogState();
}

class _ImageUploadDialogState extends State<ImageUploadDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ImageUploadDialog widget;

  @override
  Widget build(BuildContext context) {
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
                      Icons.check_circle,
                      color: PsColors.white,
                    ),
                    const SizedBox(width: PsDimens.space4),
                    Text(
                      'Upload Successful ',
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
                'Do you want to add another Image?',
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
                    widget.onPressed(true);
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
                    widget.onPressed(false);
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
  }
}
