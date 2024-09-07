import 'package:market_helper/domain/entities/markets_items/market_item.dart';

class ToolsItem extends MarketItem {
  final String id;
  ToolsItem({
    this.id = '',
    required super.name,
    required super.image,
    required super.value,
  });
}
