import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchForm extends StatefulWidget {
  final Function(Future<List<TvShow>>) onSearched;
  const SearchForm({super.key, required this.onSearched});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleSubmitSearch(String value) {
    if (_formKey.currentState!.validate()) {
      final tvShowModel = context.read<TvShowModel>();
      var shows = tvShowModel.searchTvShows(value);
      widget.onSearched(shows);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Icon(Icons.search, size: 20.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: handleSubmitSearch,
                decoration: InputDecoration(
                  hintText: "Try it",
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
