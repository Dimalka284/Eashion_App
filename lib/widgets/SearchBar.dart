import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SearchBar(
      hintText: 'Search for trends...',
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          color: isDark
              ? Colors
                    .grey
                    .shade400 // light hint on dark bg
              : Colors.grey.shade600, // dark hint on light bg
          fontSize: 16,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          Icons.search,
          size: 30,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
