import 'package:get_it/get_it.dart';
import 'package:market_helper/data/data_sources/network/interface/network_data_source.dart';
import 'package:market_helper/data/data_sources/repositories/products_data_repository_impl.dart';
import 'package:market_helper/domain/repository/products_data_repository.dart';
import 'package:market_helper/data/data_sources/network/network_data_source_impl.dart'
    if (dart.library.js) 'package:market_helper/data/data_sources/network/network_data_source_web_impl.dart';
import 'package:market_helper/global_variables.dart';

GetIt get i => GetIt.instance;

Future<void> initInjector() async {
  i.registerSingleton<NetworkDataSource>(
    NetworkDataSourceImpl(
      urlToolsBy: urlToolsBy,
      urlDealBy: urlDealBy,
    ),
  );
  i.registerSingleton<ProductsDataRepository>(
    ProductsDataRepositoryImpl(i.get()),
  );
}
