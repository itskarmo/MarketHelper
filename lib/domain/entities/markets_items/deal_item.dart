import 'dart:convert';

import 'package:market_helper/domain/entities/markets_items/market_item.dart';

class DealItem extends MarketItem {
  DealItem({
    required super.name,
    required super.image,
    required super.value,
  });
}
