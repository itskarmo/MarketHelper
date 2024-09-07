abstract class MarketItem {
  final String name;
  final String? image;
  final double value;

  const MarketItem({
    required this.name,
    required this.image,
    required this.value,
  });
}
