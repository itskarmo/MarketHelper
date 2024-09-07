import 'package:equatable/equatable.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';

enum CatalogStatus { initial, success, failure }

final class CatalogState extends Equatable {

  final CatalogStatus status;
  final String searchID;
  final List<DealItem> dealItems;
  final List<ToolsItem> toolsItems;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.searchID = 'AE-25-OF1',
    this.dealItems = const <DealItem>[],
    this.toolsItems = const <ToolsItem>[],
  });

  CatalogState copyWith({
    CatalogStatus? status,
    String? searchID,
    List<DealItem>? dealItems,
    List<ToolsItem>? toolsItems,
  }) {
    return CatalogState(
      status: status ?? this.status,
      searchID: searchID ?? this.searchID,
      dealItems: dealItems ?? this.dealItems,
      toolsItems: toolsItems ?? this.toolsItems,
    );
  }

  @override
  String toString() {
    return '''CatalogState { status: $status, searchID: $searchID, dealItems: ${dealItems.length}, toolsItems: ${toolsItems.length} }''';
  }

  @override
  List<Object> get props => [status, searchID, dealItems, toolsItems];
}