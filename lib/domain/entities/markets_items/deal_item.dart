import 'dart:convert';

import 'package:market_helper/domain/entities/markets_items/market_item.dart';

class DealItem extends MarketItem {
  final String companyName;
  final String regionName;
  final String link;
  DealItem({
    required super.name,
    this.companyName = '',
    this.regionName = '',
    this.link = '',
    required super.image,
    required super.value,
  });
}
