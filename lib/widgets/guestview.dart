import 'package:eashion2/screen/auth_screen.dart';
import 'package:flutter/material.dart';

class GuestView extends StatelessWidget {
  final String title;
  final String description;
  const GuestView({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: colorScheme.primary,
              size: 180,
            ),
            const SizedBox(height: 40),
            Text(
              title.toUpperCase(), 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900, 
                letterSpacing: 4,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5, 
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      colorScheme.primary, 
                  foregroundColor:
                      colorScheme.onPrimary,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary, width: 1.5),
                  foregroundColor: colorScheme.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
                child: const Text(
                  'JOIN',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
