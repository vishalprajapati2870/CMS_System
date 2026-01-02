import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/globals/site_service.dart';
import 'package:cms/components/animated_dropdown.dart';

class SiteSelector extends StatelessWidget {
  final String? selectedSite;
  final ValueChanged<String?> onSiteChanged;

  const SiteSelector({
    super.key,
    required this.selectedSite,
    required this.onSiteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Consumer<SiteService>(
        builder: (context, siteService, child) {
          final sites = siteService.sites;
          final allSites = ['All Sites', ...sites.map((site) => site.siteName).toList()];

          return AnimatedDropdown<String>(
            value: selectedSite,
            items: allSites,
            hintText: 'Select Site',
            // enableSearch: false,
            itemLabelBuilder: (item) => item,
            onChanged: onSiteChanged,
          );
        },
      ),
    );
  }
}