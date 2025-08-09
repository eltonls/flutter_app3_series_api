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
  late Future<TvShow> _tvShowFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    final tvShowId = state.uri.queryParameters["id"];
    final tvShowModel = context.read<TvShowModel>();

    if (tvShowId != null) {
      final id = int.tryParse(tvShowId);
      if (id != null) {
        _tvShowFuture = tvShowModel.getTvShowById(id);
      } else {
        _tvShowFuture = Future.error('Invalid TV show ID');
      }
    } else {
      _tvShowFuture = Future.error('Missing TV show ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TvShow>(
        future: _tvShowFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildTvShowDetails(snapshot.data!);
          } else {
            return const Center(
              child: Text('Nenhum dado encontrado'),
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ops! Algo deu errado',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar os detalhes da série.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => setState(() {
                    // Triggers rebuild and retry
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTvShowDetails(TvShow tvShow) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(tvShow),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(tvShow),
                const SizedBox(height: 16),
                _buildMetadataSection(tvShow),
                const SizedBox(height: 24),
                _buildSummarySection(tvShow),
                const SizedBox(height: 32),
                _buildActionButtons(tvShow),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(TvShow tvShow) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage(tvShow),
      ),
      actions: [
        Consumer<TvShowModel>(
          builder: (context, tvShowModel, child) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FutureBuilder<bool>(
                future: tvShowModel.isFavorite(tvShow),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;

                  return IconButton(
                    onPressed: snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : () => _toggleFavorite(tvShow, isFavorite),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? SizedBox(
                        key: const ValueKey('loading'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 28,
                      ),
                    ),
                    tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroImage(TvShow tvShow) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: tvShow.imageUrl.isNotEmpty
          ? Image.network(
        tvShow.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.tv_rounded,
          size: 80,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildTitleSection(TvShow tvShow) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tvShow.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (tvShow.webChannel.isNotEmpty && tvShow.webChannel != 'N/A') ...[
          const SizedBox(height: 4),
          Text(
            'Exibido em ${tvShow.webChannel}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetadataSection(TvShow tvShow) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (tvShow.rating > 0)
          _buildInfoChip(
            icon: Icons.star_rounded,
            label: '${tvShow.rating.toStringAsFixed(1)} ⭐',
            color: Colors.amber,
          ),
        if (tvShow.webChannel.isNotEmpty && tvShow.webChannel != 'N/A')
          _buildInfoChip(
            icon: Icons.tv_rounded,
            label: tvShow.webChannel,
            color: theme.colorScheme.primary,
          ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(TvShow tvShow) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sinopse',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildSummaryContent(tvShow, theme),
        ),
      ],
    );
  }

  Widget _buildSummaryContent(TvShow tvShow, ThemeData theme) {
    if (tvShow.summary.isNotEmpty &&
        tvShow.summary != "No summary available" &&
        tvShow.summary != "summary_not_found") {
      return HtmlWidget(
        tvShow.summary,
        textStyle: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: theme.colorScheme.onSurface,
        ),
      );
    }

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Sinopse não disponível para esta série.',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(TvShow tvShow) {
    return Consumer<TvShowModel>(
      builder: (context, tvShowModel, child) {
        return FutureBuilder(
          future: tvShowModel.isFavorite(tvShow),
          builder: (context, asyncSnapshot) {
            final isFavorite = asyncSnapshot.data ?? false;

            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _toggleFavorite(tvShow, isFavorite),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                      ),
                    ),
                    label: Text(isFavorite ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isFavorite ? Colors.red : null,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go("/"),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _toggleFavorite(TvShow tvShow, bool isFavorite) {
    final tvShowModel = context.read<TvShowModel>();
    print("Teste: ${tvShow.name} - Favorito: $isFavorite");

    if (!isFavorite) {
      tvShowModel.addToFavorites(tvShow);
    } else {
      tvShowModel.removeFromFavorites(tvShow);
    }
  }
}