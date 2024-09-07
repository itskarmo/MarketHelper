import 'package:market_helper/domain/repository/products_data_repository.dart';
import 'package:market_helper/presentation/di/injector.dart';

void main() async {
  initInjector();

  // final marketItem =
  //     await i<ProductsDataRepository>().getProductByIdDealBy('AE-50-OF1');
  final toolsPrice =
      await i<ProductsDataRepository>().getProductByIdToolsBy('AE-50-OF1');
  final dealPrices = await i<ProductsDataRepository>().getProductsByIdDealBy('AE-50-OF1');
  dealPrices.forEach((element) {print(element.value);});
  print('tools price ${toolsPrice.value}');
  // print(marketItem.name);
  // print(marketItem.value);
}
