
import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistBottomEditBar extends StatelessWidget {
  const WishlistBottomEditBar({
    super.key,
    required this.mounted,
  });

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: wishlist.deleteSelected,
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () async {
                final wishlist = context.read<WishlistProvider>();
                final token = await UserSessionService().getToken();
                await wishlist.moveSelectedToCart(token!);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Moved to shopping bag')),
                );
              },
              child: const Text(
                'Move to Bag',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

