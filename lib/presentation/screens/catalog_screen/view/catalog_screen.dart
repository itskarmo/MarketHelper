import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_helper/domain/repository/products_data_repository.dart';
import 'package:market_helper/presentation/di/injector.dart';
import 'package:market_helper/presentation/screens/catalog_screen/bloc/catalog_bloc.dart';
import 'package:market_helper/presentation/screens/catalog_screen/bloc/catalog_event.dart';
import 'package:market_helper/presentation/screens/catalog_screen/bloc/catalog_state.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO move to main file
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (BuildContext context) => CatalogBloc(
            i<ProductsDataRepository>(),
          )..add(CatalogFetched()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const Center(child: Icon(Icons.search, size: 30)),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                        onSubmitted: (searchText) => context.read<CatalogBloc>()
                          ..add(NewCatalogSearch(newCatalogSearch: searchText))
                          ..add(CatalogFetched()),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: switch (state.status) {
                    CatalogStatus.initial => Center(
                        child: Text(state.userMessage),
                      ),
                    CatalogStatus.success => Column(
                        children: [
                          ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1.5,
                              child: Image.network(
                                state.toolsItems.first.image ??
                                    'https://static.vecteezy.com/system/resources/thumbnails/022/014/063/small_2x/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg',
                              ),
                            ),
                            title: SelectableText(
                              state.toolsItems.first.name,
                              //style: const TextStyle(fontSize: 30),
                            ),
                            subtitle: SelectableText(
                              state.toolsItems.first.value.toString(),
                              //style: const TextStyle(fontSize: 30),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.dealItems.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Image.network(
                                      state.dealItems[index].image ??
                                          'https://static.vecteezy.com/system/resources/thumbnails/022/014/063/small_2x/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg',
                                    ),
                                  ),
                                  title: SelectableText(
                                    state.dealItems[index].name,
                                    //style: const TextStyle(fontSize: 30),
                                  ),
                                  subtitle: SelectableText(
                                    state.dealItems[index].value.toString(),
                                    //style: const TextStyle(fontSize: 30),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    CatalogStatus.failure => Center(
                        child: Text(state.userMessage),
                      ),
                    CatalogStatus.inProgress => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
