import 'dart:convert';

import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TvShowScreen extends StatefulWidget {
  const TvShowScreen({super.key});

  @override
  State<TvShowScreen> createState() => _TvShowScreenState();
}

class _TvShowScreenState extends State<TvShowScreen> {
  late Future<TvShow>? tvShow;

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final tvShowId = state.uri.queryParameters["id"];
    final tvShowModel = context.watch<TvShowModel>();

    setState(() {
      tvShow = tvShowModel.fetchTvShowById(int.parse(tvShowId!));
    });

    return FutureBuilder(future: tvShow, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        final tvShowData = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Image.network(tvShowData.image, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                Text(
                  tvShowData.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 8),
                Text('Rating: ${tvShowData.rating.toStringAsFixed(1)}', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Web Channel: ${tvShowData.webChannel}', style: TextStyle(fontSize: 12),),
                const SizedBox(height: 16),
                HtmlWidget(tvShowData.summary),
              ],
            ),
          );
      } else {
        return const Center(child: Text('No data found'));
      }
    });
  }
}