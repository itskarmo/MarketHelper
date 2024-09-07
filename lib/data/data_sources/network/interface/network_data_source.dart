import 'package:http/http.dart' as http;
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';

abstract class NetworkDataSource {
  Future<String> getSessionIdToolsBy();

  Future<ToolsItem> getProductByIdToolsBy(String id);

  Future<List<DealItem>> getProductsByIdDealBy(String id);

  Future<DealItem> getProductByIdDealBy(String id);
}
