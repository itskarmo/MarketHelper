import 'package:equatable/equatable.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

final class CatalogFetched extends CatalogEvent {}

final class NewCatalogSearch extends CatalogEvent {
  final String newCatalogSearch;
  const NewCatalogSearch({required this.newCatalogSearch});
}

final class CatalogFilterPriceFromChange extends CatalogEvent {
  final String priceFrom;
  const CatalogFilterPriceFromChange(this.priceFrom);
}
