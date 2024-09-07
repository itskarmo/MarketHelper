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
            switch (state.status) {
              case CatalogStatus.failure:
                return const Center(child: Text('failed to fetch posts'));
              case CatalogStatus.success:
                if (state.dealItems.isEmpty && state.toolsItems.isEmpty) {
                  return const Center(child: Text('no posts'));
                }
                return Column(
                  children: [
                    ListTile(
                      leading: Image.network(state.toolsItems.first.image ??
                          'https://static.vecteezy.com/system/resources/thumbnails/022/014/063/small_2x/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg'),
                      title: Text(
                        state.toolsItems.first.name,
                        //style: const TextStyle(fontSize: 30),
                      ),
                      subtitle: Text(
                        state.toolsItems.first.value.toString(),
                        //style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.dealItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.network(state.dealItems[index].image ??
                                'https://static.vecteezy.com/system/resources/thumbnails/022/014/063/small_2x/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg'),
                            title: Text(
                              state.dealItems[index].name,
                              //style: const TextStyle(fontSize: 30),
                            ),
                            subtitle: Text(
                              state.dealItems[index].value.toString(),
                              //style: const TextStyle(fontSize: 30),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              case CatalogStatus.initial:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
