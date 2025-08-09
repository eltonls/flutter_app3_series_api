import 'package:app3_series_api/my_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeModel = context.watch<MyThemeModel>();

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, theme, themeModel),
          Expanded(
            child: _buildDrawerContent(context, theme),
          ),
          _buildDrawerFooter(context, theme),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, ThemeData theme, MyThemeModel themeModel) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.tv,
                  size: 40,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Eu Amo Séries',
                style: GoogleFonts.lobster(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '🎬',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              _buildThemeToggleButton(context, theme, themeModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggleButton(BuildContext context, ThemeData theme, MyThemeModel themeModel) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.read<MyThemeModel>().toggleTheme(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeModel.isDark
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_round,
                  key: ValueKey(themeModel.isDark),
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                themeModel.isDark ? 'Modo Claro' : 'Modo Escuro',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context, ThemeData theme) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildDrawerItem(
          context: context,
          theme: theme,
          icon: Icons.favorite_rounded,
          title: 'Minhas Favoritas',
          subtitle: 'Séries que você salvou',
          route: '/',
          currentRoute: currentRoute,
        ),
        _buildDrawerItem(
          context: context,
          theme: theme,
          icon: Icons.search_rounded,
          title: 'Buscar Séries',
          subtitle: 'Encontre novas séries',
          route: '/search',
          currentRoute: currentRoute,
        ),
        const Divider(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Configurações',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildDrawerItem(
          context: context,
          theme: theme,
          icon: Icons.settings_rounded,
          title: 'Configurações',
          subtitle: 'Personalize o app',
          onTap: () => _showSettingsDialog(context),
        ),
        _buildDrawerItem(
          context: context,
          theme: theme,
          icon: Icons.info_outline_rounded,
          title: 'Sobre o App',
          subtitle: 'Versão e informações',
          onTap: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    String? route,
    String? currentRoute,
    VoidCallback? onTap,
  }) {
    final isSelected = route != null && currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: onTap ?? () {
          Navigator.of(context).pop();
          if (route != null) {
            context.go(route);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.tv_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Descubra suas próximas séries favoritas',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações'),
        content: const Text('Em breve mais opções de personalização!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Navigator.of(context).pop();
    showAboutDialog(
      context: context,
      applicationName: 'Eu Amo Séries',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.tv, size: 48),
      children: [
        const Text('Um app para descobrir e organizar suas séries favoritas.'),
        const SizedBox(height: 8),
        const Text('Desenvolvido com Flutter 💙'),
      ],
    );
  }
}