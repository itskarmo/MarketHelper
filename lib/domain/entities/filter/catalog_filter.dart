import 'package:equatable/equatable.dart';

class CatalogFilter extends Equatable {
  final double priceFrom;
  final bool sortByPrice;

  const CatalogFilter({
    this.priceFrom = 0.0,
    this.sortByPrice = true,
  });

  CatalogFilter copyWith({
    double? priceFrom,
    bool? sortByPrice,
  }) {
    return CatalogFilter(
      priceFrom: priceFrom ?? this.priceFrom,
      sortByPrice: sortByPrice ?? this.sortByPrice,
    );
  }

  @override
  String toString() {
    return 'priceFrom: $priceFrom, sortByPrice: $sortByPrice';
  }

  @override
  List<Object?> get props => [priceFrom, sortByPrice];
}
