import 'package:equatable/equatable.dart';
import 'package:market_helper/domain/entities/filter/catalog_filter.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';

enum CatalogStatus { initial, success, failure, inProgress }

final class CatalogState extends Equatable {

  final CatalogStatus status;
  final String searchID;
  final String userMessage;
  final CatalogFilter catalogFilter;
  final List<DealItem> dealItems;
  final List<ToolsItem> toolsItems;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.searchID = 'AE-25-OF1',
    this.userMessage = 'Search for your product',
    this.catalogFilter = const CatalogFilter(),
    this.dealItems = const <DealItem>[],
    this.toolsItems = const <ToolsItem>[],
  });

  CatalogState copyWith({
    CatalogStatus? status,
    String? searchID,
    String? userMessage,
    CatalogFilter? catalogFilter,
    List<DealItem>? dealItems,
    List<ToolsItem>? toolsItems,
  }) {
    return CatalogState(
      status: status ?? this.status,
      searchID: searchID ?? this.searchID,
      userMessage: userMessage ?? this.userMessage,
      catalogFilter: catalogFilter ?? this.catalogFilter,
      dealItems: dealItems ?? this.dealItems,
      toolsItems: toolsItems ?? this.toolsItems,
    );
  }

  @override
  String toString() {
    return '''CatalogState { status: $status, searchID: $searchID, userMessage: $userMessage, $catalogFilter, dealItems: ${dealItems.length}, toolsItems: ${toolsItems.length} }''';
  }

  @override
  List<Object> get props => [status, searchID, userMessage, catalogFilter, dealItems, toolsItems];
}