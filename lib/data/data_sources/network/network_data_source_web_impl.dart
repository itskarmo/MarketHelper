import 'dart:convert';
import 'dart:js_interop';
import 'package:market_helper/data/data_sources/network/interface/network_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:market_helper/domain/entities/filter/catalog_filter.dart';
import 'package:market_helper/domain/entities/markets_items/deal_item.dart';
import 'package:market_helper/domain/entities/markets_items/tools_item.dart';
import 'package:market_helper/global_variables.dart';
import 'package:web/web.dart' as web;

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
    print(r.headersSplitValues  );
    if (cookies != null) {
      final sessionId = cookies.split(';');
      return sessionId.first;
    }
    return '';
    //throw Exception('No authorization cookies');
  }

  @override
  Future<ToolsItem> getProductByIdToolsBy(String id) async {
    final toolsUri = Uri.parse('$urlToolsBy/?q=kat&part=1&keys=$id');
    final cookies = await getSessionIdToolsBy();
    final result = await http.get(toolsUri);

    var document = web.Document.parseHTMLUnsafe(result.body.jsify()!);
    String? route = document
        .getElementsByClassName("div_naimen no_border")
        .item(0)
        ?.getElementsByTagName("a")
        .item(0)
        ?.attributes
        .getNamedItem("href")
        ?.nodeValue;
    if (route != null) {
      final itemWebPageRes = await http.get(
        Uri.parse('$urlToolsBy$route'),
        headers: <String, String>{
          'Cookie':
              '_ga=GA1.1.864502525.1706892602; _ym_uid=1706892602475086673; _ym_d=1725131910; _ga_EFV5FBE1K5=GS1.1.1709943679.11.0.1709943679.0.0.0; _ym_isad=2; _ga_SS4WGWKNK5=GS1.1.1725198962.3.1.1725199868.0.0.0; tr_rb=hide; SESS537409fb5a269f5e5b917d99f94d2daf=fce86e63b6ec4f386ae66aadc9c479d2'
        },
      );
      final webDocument = web.Document.parseHTMLUnsafe(itemWebPageRes.body.jsify()!);
      final itemPrice = webDocument
          .getElementsByClassName("b_price_numbers")
          .item(1)
          ?.getElementsByTagName("span")
          .item(0)
          ?.innerHTML.toString();
      return ToolsItem(
        name: id,
        image: 'image',
        // TODO use tryParse in future
        value: double.parse(itemPrice!.replaceFirst(',', '.')),
      );
    }
    throw Exception('No price found');
  }

  @override
  Future<DealItem> getProductByIdDealBy(String id) async {
    final dealUri = Uri.parse('$urlDealBy/search?search_term=$id&sort=price');
    print('object');
    final result = await http.get(
      dealUri,
      headers: {"Origin": 'https://deal.by/'},
    );

    var document = web.Document.parseHTMLUnsafe(result.body.jsify()!);
    final coins = document
        .getElementsByClassName("yzKb6")
        .item(0)
        ?.parentElement
        ?.attributes
        .getNamedItem('data-qaprice')
        ?.value;
    print(coins);
    if (coins != null) {
      print(double.parse(coins.replaceFirst(',', '.')));
      return DealItem(
        name: id,
        companyName: id,
        regionName: id,
        image: 'image',
        // TODO use tryParse in future
        value: double.parse(coins.replaceFirst(',', '.')),
      );
    }
    throw Exception('No price found');
  }

  @override
  Future<List<DealItem>> getProductsByIdDealBy(String id, CatalogFilter? filter) async {
    final dealUri = Uri.parse('$urlDealBy/search?search_term=$id&sort=price');
    final result = await http.get(dealUri);
    var document = web.Document.parseHTMLUnsafe(result.body.jsify()!);
    final classElements =
        document.getElementById('react-portal')?.nextElementSibling?.innerHTML;
    final jsonStart = classElements.toString().lastIndexOf('"products":[{');
    final jsonEnd = classElements.toString().lastIndexOf('"productsBadMatch":[],');
    final data = classElements.toString().substring(jsonStart! + 11, jsonEnd! - 1);
    final dealItems = <DealItem>[];
    if (data != null) {
      final json = jsonDecode(data) as List<dynamic>;
      for (int i = 0; i < json.length; i++) {
        if ((json[i]['product']['nameForCatalog'] as String).contains(id)) {
          dealItems.add(
            DealItem(
              name: json[i]['product']['nameForCatalog'],
              companyName: json[i]['product']['nameForCatalog'],
              regionName: json[i]['product']['nameForCatalog'],
              image: json[i]['product']['image({"height":200,"width":200})'],
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
    return dealItems;
  }
}
