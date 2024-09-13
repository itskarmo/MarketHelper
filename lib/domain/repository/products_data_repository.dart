import 'package:market_helper/domain/entities/filter/catalog_filter.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';

abstract class ProductsDataRepository {
  Future<ToolsItem> getProductByIdToolsBy(String id);
  Future<DealItem> getProductByIdDealBy(String id);
  Future<List<DealItem>> getProductsByIdDealBy(String id, CatalogFilter? filter);
}
