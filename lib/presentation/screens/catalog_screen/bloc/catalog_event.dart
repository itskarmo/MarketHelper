import 'package:equatable/equatable.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object> get props => [];
}

final class CatalogFetched extends CatalogEvent {}

final class NewCatalogSearch extends CatalogEvent {
  const NewCatalogSearch({required this.newCatalogSearch});
  final String newCatalogSearch;
}
