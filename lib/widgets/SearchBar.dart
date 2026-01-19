import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SearchBar(
      hintText: 'Search for trends...',
      leading: Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(Icons.search, size: 30, color: Colors.grey),
      ),
    );
  }
}