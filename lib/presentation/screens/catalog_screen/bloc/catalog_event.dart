import 'package:equatable/equatable.dart';

sealed class CatalogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CatalogFetched extends CatalogEvent {}

final class NewCatalogSearch extends CatalogEvent {}