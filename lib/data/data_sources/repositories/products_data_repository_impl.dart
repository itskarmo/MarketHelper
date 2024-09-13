import 'package:market_helper/data/data_sources/network/interface/network_data_source.dart';
import 'package:market_helper/domain/entities/filter/catalog_filter.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';
import 'package:market_helper/domain/repository/products_data_repository.dart';

class ProductsDataRepositoryImpl implements ProductsDataRepository {
  final NetworkDataSource _networkDataSource;

  ProductsDataRepositoryImpl(this._networkDataSource);

  @override
  Future<ToolsItem> getProductByIdToolsBy(String id) =>
      _networkDataSource.getProductByIdToolsBy(id);

  @override
  Future<DealItem> getProductByIdDealBy(String id) =>
      _networkDataSource.getProductByIdDealBy(id);

  @override
  Future<List<DealItem>> getProductsByIdDealBy(String id, CatalogFilter? filter) =>
      _networkDataSource.getProductsByIdDealBy(id, filter);
}
