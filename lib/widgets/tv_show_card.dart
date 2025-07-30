
import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TvShowCard extends StatelessWidget {
  final TvShow tvShow;
  const TvShowCard({super.key, required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(Uri(path: "/tvShows/detail", queryParameters: {"id": tvShow.id.toString()}).toString()),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              tvShow.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tvShow.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Rating: ${tvShow.rating.toStringAsFixed(1)}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tvShow.webChannel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}