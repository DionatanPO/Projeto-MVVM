import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final bool isExtended;
  final double topPadding;

  const HomeSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isExtended,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: isExtended,
      minExtendedWidth: 260,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      labelType: NavigationRailLabelType.none,
      useIndicator: true,
      leading: Padding(
        padding: EdgeInsets.only(
          top: topPadding + 24,
          bottom: 40,
        ),
        child: _SidebarHeader(isExtended: isExtended),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _SidebarFooter(isExtended: isExtended),
          ),
        ),
      ),
      destinations: [
        _buildDestination(
          icon: Icons.space_dashboard_rounded,
          label: 'Dashboard',
          colorScheme: colorScheme,
        ),
        _buildDestination(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Carteira',
          colorScheme: colorScheme,
        ),
        _buildDestination(
          icon: Icons.bar_chart_rounded,
          label: 'Relatórios',
          colorScheme: colorScheme,
        ),
        _buildDestination(
          icon: Icons.settings_rounded,
          label: 'Configurações',
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  NavigationRailDestination _buildDestination({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return NavigationRailDestination(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Icon(icon, size: 24),
      ),
      selectedIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Icon(
          icon,
          size: 24,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final bool isExtended;
  const _SidebarHeader({required this.isExtended});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment:
      isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.rocket_launch_rounded,
            color: colorScheme.onPrimary,
            size: 22,
          ),
        ),
        if (isExtended) ...[
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Finances",
                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Pro",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  final bool isExtended;
  const _SidebarFooter({required this.isExtended});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person_rounded,
              size: 18,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          if (isExtended) ...[
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Usuário",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  "user@email.com",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}