import 'package:bloc/bloc.dart';
import 'package:market_helper/domain/repository/products_data_repository.dart';
import 'package:market_helper/presentation/screens/catalog_screen/bloc/catalog_state.dart';
import 'catalog_event.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ProductsDataRepository productsDataRepository;

  CatalogBloc(this.productsDataRepository) : super(const CatalogState()) {
    on<CatalogFetched>(_onCatalogFetched);
    on<NewCatalogSearch>(_newCatalogSearch);
  }

  Future<void> _onCatalogFetched(
      CatalogFetched event, Emitter<CatalogState> emit) async {
    try {
      emit(state.copyWith(status: CatalogStatus.inProgress));
      final toolsItem =
          await productsDataRepository.getProductByIdToolsBy(state.searchID);
      final dealItems =
          await productsDataRepository.getProductsByIdDealBy(state.searchID);
      if (dealItems.isEmpty) throw Exception(['No Deal data found']);
      if (toolsItem.name == '') throw Exception(['No Tools data found']);
      emit(
        state.copyWith(
          status: CatalogStatus.success,
          dealItems: dealItems,
          toolsItems: [toolsItem],
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: CatalogStatus.failure, userMessage: e.toString()));
    }
  }

  Future<void> _newCatalogSearch(
          NewCatalogSearch event, Emitter<CatalogState> emit) async =>
      emit(state.copyWith(searchID: event.newCatalogSearch));
}
