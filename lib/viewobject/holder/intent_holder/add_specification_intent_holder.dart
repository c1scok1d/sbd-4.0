import 'package:flutter/material.dart';
import 'package:businesslistingapi/provider/specification/specification_provider.dart';

class SpecificationIntentHolder {
  const SpecificationIntentHolder({
    @required this.itemId,
    @required this.specificationProvider,
    @required this.name,
    @required this.description,
  });
  final String itemId;
  final SpecificationProvider specificationProvider;
  final String name;
  final String description;
}
