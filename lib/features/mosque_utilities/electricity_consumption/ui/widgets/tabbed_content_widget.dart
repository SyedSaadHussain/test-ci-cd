import 'package:flutter/material.dart';

import 'all_mosques_section_widget.dart';

// Deprecated: Previously used to show tabs. Now AllMosquesSectionWidget is used directly.
class TabbedContentWidget extends StatelessWidget {
  const TabbedContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllMosquesSectionWidget();
  }
}
