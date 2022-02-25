// import 'package:businesslistingapi/config/ps_colors.dart';
// import 'package:businesslistingapi/config/ps_config.dart';
// import 'package:businesslistingapi/ui/specification/add_specification/add_specification_view.dart';
// import 'package:businesslistingapi/utils/utils.dart';
// import 'package:flutter/material.dart';

// class AddSpecificationContainerView extends StatefulWidget {
//   const AddSpecificationContainerView({Key key, @required this.itemId})
//       : super(key: key);
//   final String itemId;
//   @override
//   _AddSpecificationContainerViewState createState() =>
//       _AddSpecificationContainerViewState();
// }

// class _AddSpecificationContainerViewState
//     extends State<AddSpecificationContainerView>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;
//   @override
//   void initState() {
//     animationController =
//         AnimationController(duration: PsConfig.animation_duration, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> _requestPop() {
//       animationController.reverse().then<dynamic>(
//         (void data) {
//           if (!mounted) {
//             return Future<bool>.value(false);
//           }
//           Navigator.pop(context, true);
//           return Future<bool>.value(true);
//         },
//       );
//       return Future<bool>.value(false);
//     }

//     print(
//         '............................Build UI Again ............................');
//     return WillPopScope(
//       onWillPop: _requestPop,
//       child: Scaffold(
//         appBar: AppBar(
//           brightness: Utils.getBrightnessForAppBar(context),
//           iconTheme: Theme.of(context)
//               .iconTheme
//               .copyWith(color: PsColors.mainColorWithWhite),
//           title: Text(
//               Utils.getString(context, 'addSpecification__app_bar_name'),
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline6
//                   .copyWith(fontWeight: FontWeight.bold)
//                   .copyWith(color: PsColors.mainColorWithWhite)),
//           elevation: 0,
//         ),
//         body: Container(
//           color: PsColors.coreBackgroundColor,
//           height: double.infinity,
//           child: AddSpecificationView(
//             animationController: animationController,
//             itemId: widget.itemId,
//           ),
//         ),
//       ),
//     );
//   }
// }
