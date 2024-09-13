import 'dart:convert';
import 'package:market_helper/data/data_sources/network/interface/network_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:market_helper/domain/entities/filter/catalog_filter.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';
import 'package:html/parser.dart';
import 'package:market_helper/global_variables.dart';

class NetworkDataSourceImpl implements NetworkDataSource {
  final String urlToolsBy;
  final String urlDealBy;

  NetworkDataSourceImpl({
    required this.urlToolsBy,
    required this.urlDealBy,
  });

  @override
  Future<String> getSessionIdToolsBy() async {
    final r = await http.post(
      Uri.parse('$urlToolsBy/user/login'),
      encoding: Encoding.getByName('utf-8'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'cookie':
            '_ga=GA1.1.864502525.1706892602; _ym_uid=1706892602475086673; _ym_d=1725131910; tr_rb=hide; SESS537409fb5a269f5e5b917d99f94d2daf=8af7c9a2863531dc7e09b3a5daf4a8b3; _ga_EFV5FBE1K5=GS1.1.1725201875.12.0.1725202971.0.0.0; _ym_isad=2; _ga_SS4WGWKNK5=GS1.1.1725444639.5.1.1725444885.0.0.0',
      },
      body: <String, String>{
        'name': toolsName,
        'pass': toolsPass,
        'op': 'Войти в систему',
        'form_id': 'user_login',
      },
    );
    final cookies = r.headers['set-cookie'];
    if (cookies != null) {
      final sessionId = cookies.split(';');
      return sessionId.first;
    }
    throw Exception('No authorization cookies');
  }

  @override
  Future<ToolsItem> getProductByIdToolsBy(String id) async {
    final toolsUri = Uri.parse('$urlToolsBy/?q=kat&part=1&keys=$id');
    final cookies = await getSessionIdToolsBy();
    final result = await http.get(toolsUri);
    try {
      final document = parse(result.body);
      String route = document
          .getElementsByClassName("div_naimen no_border")
          .first
          .getElementsByTagName("a")
          .first
          .attributes
          .values
          .first;
      if (route.contains('//tools.by')) {
        route = document
            .getElementsByClassName("div_naimen no_border")
            .first
            .getElementsByTagName("a")[1]
            .attributes
            .values
            .first;
      }
      print(route);
      final itemWebPageRes = await http.get(
        Uri.parse('$urlToolsBy$route'),
        headers: <String, String>{'Cookie': 'tr_rb=hide; $cookies'},
      );
      final webDocument = parse(itemWebPageRes.body);
      final itemPrice = webDocument
          .getElementsByClassName("b_price_numbers")[1]
          .getElementsByTagName("span")
          .first
          .innerHtml;
      final itemName = webDocument
          .getElementsByClassName("div_naimen")
          .first
          .getElementsByTagName("h1")
          .first
          .innerHtml;
      final itemImage = webDocument
          .getElementsByClassName("image_block_show")[0]
          .attributes
          .values
          .elementAt(1);
      return ToolsItem(
        id: id,
        name: itemName,
        image: itemImage,
        value: double.parse(itemPrice.replaceFirst(',', '.')),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DealItem>> getProductsByIdDealBy(
    String id,
    CatalogFilter? filter,
  ) async {
    final dealItems = <DealItem>[];
    String priceFrom = '';
    if (filter != null) priceFrom = '&price_local__gte=${filter.priceFrom}';
    final dealUri = Uri.parse('$urlDealBy/search?search_term=$id&sort=price');
    final result = await http.get(dealUri);
    for (int i = 1; i <= 3; i++) {
      String page = '';
      if (i != 1) page = '&page=$i';
      final dealUri = Uri.parse(
          '$urlDealBy/search?search_term=$id&sort=price$priceFrom$page');
      print(dealUri.toString());
      final result = await http.get(dealUri);
      var document = parse(result.body);
      final classElements = document
          .getElementById('react-portal')
          ?.nextElementSibling
          ?.innerHtml
          .toString();
      final jsonStart = classElements?.lastIndexOf('"products":[{');
      final jsonEnd = classElements?.lastIndexOf('"productsBadMatch":[],');
      print('$jsonStart, $jsonEnd');
      if (jsonStart != -1 && jsonEnd != -1) {
        final data = classElements?.substring(jsonStart! + 11, jsonEnd! - 1);
        if (data != null) {
          final json = jsonDecode(data) as List<dynamic>;
          for (int i = 0; i < json.length; i++) {
            final catalogName = json[i]['product']['nameForCatalog'] as String;
            if (catalogName.contains(id.toUpperCase()) ||
                catalogName.contains(id.toLowerCase()) ||
                catalogName.contains(id)) {
              dealItems.add(
                DealItem(
                  name: json[i]['product']['nameForCatalog'],
                  companyName: json[i]['product']['company']['name'],
                  regionName: json[i]['product']['company']['regionName'],
                  link: json[i]['product']['urlForProductCatalog'],
                  image: json[i]['product']
                      ['image({"height":200,"width":200})'],
                  value: double.parse(
                    json[i]['product']['hasDiscount'] == true
                        ? json[i]['product']['discountedPrice']
                        : json[i]['product']['price'],
                  ),
                ),
              );
            }
          }
        }
      }
      print(dealItems.length);
    }
    return dealItems;
  }

  @override
  Future<DealItem> getProductByIdDealBy(String id) {
    // TODO: implement getProductByIdDealBy
    throw UnimplementedError();
  }
}
