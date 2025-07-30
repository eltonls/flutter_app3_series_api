import 'package:app3_series_api/tv_show_model.dart';
import 'package:app3_series_api/widgets/search_form.dart';
import 'package:app3_series_api/widgets/tv_show_card.dart';
import 'package:flutter/material.dart';

class TvShowSearchScreen extends StatefulWidget {
  const TvShowSearchScreen({super.key});

  @override
  State<TvShowSearchScreen> createState() => _TvShowSearchScreenState();
}

class _TvShowSearchScreenState extends State<TvShowSearchScreen> {
  Future<List<TvShow>>? _searchResults;

  void setSearchResults(Future<List<TvShow>> shows) {
    setState(() {
      _searchResults = shows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchForm(onSearched: setSearchResults),
            ),
            FutureBuilder(future: _searchResults, builder: (context, snapshot) =>
              snapshot.hasData
                  ? Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 2 / 3, // Poster aspect ratio
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return TvShowCard(tvShow: snapshot.data![index]);
                        },
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}