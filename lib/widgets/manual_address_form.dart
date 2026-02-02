import 'package:eashion2/widgets/checkout_Text_field.dart';
import 'package:eashion2/widgets/location_action_btn.dart';
import 'package:flutter/material.dart';

class ManualAddressForm extends StatelessWidget {
  final TextEditingController townController;
  final TextEditingController postalController;
  final TextEditingController districtController;
  final TextEditingController provinceController;
  final VoidCallback onApply;

  const ManualAddressForm({
    super.key,
    required this.townController,
    required this.postalController,
    required this.districtController,
    required this.provinceController,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      color: colorScheme.secondary,
      child: Column(
        children: [
          CheckoutTextField(
            nameController: townController,
            lable: "Town",
            icon: Icons.location_city,
          ),
          const SizedBox(height: 10),
          CheckoutTextField(
            nameController: postalController,
            lable: "Postal Code",
            icon: Icons.local_post_office,
          ),
          const SizedBox(height: 10),
          CheckoutTextField(
            nameController: districtController,
            lable: "District",
            icon: Icons.map,
          ),
          const SizedBox(height: 10),
          CheckoutTextField(
            nameController: provinceController,
            lable: "Province",
            icon: Icons.explore,
          ),
          const SizedBox(height: 15),
          LocationActionButton(
            context: context,
            label: "APPLY ADDRESS",
            icon: Icons.check_circle_outline,
            onTap: onApply,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}