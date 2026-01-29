import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/widgets/checkout_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:eashion2/services/location_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;
  const CheckoutScreen({super.key, required this.selectedItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _masterAddressController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();

  bool showPostalFields = false;

  // Calculate Total Price
  double get totalAmount {
    return widget.selectedItems.fold(0, (sum, item) {
      final discountedPrice = item.product.price - (item.product.price * item.product.discount / 100);
      return sum + (discountedPrice * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'CHECKOUT',
          style: TextStyle(
            letterSpacing: 4, 
            fontWeight: FontWeight.w300, 
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, "01", "SHIPPING DETAILS"),
                  const SizedBox(height: 20),
                  
                  // Contact Inputs
                  CheckoutTextField(
                    nameController: _nameController,
                    lable: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),
                  CheckoutTextField(
                    nameController: _numberController,
                    lable: "Phone Number",
                    icon: Icons.phone_android_outlined,
                  ),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, "02", "DESTINATION"),
                  const SizedBox(height: 15),

                  // Master Address View
                  _buildAddressDisplay(colorScheme),
                  const SizedBox(height: 15),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(child: _buildActionButton(context, "GPS LOCATE", Icons.my_location, _useGps, true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildActionButton(context, "POSTAL", Icons.edit_location_alt_outlined, () {
                        setState(() => showPostalFields = !showPostalFields);
                      }, false)),
                    ],
                  ),

                  if (showPostalFields) _buildPostalForm(colorScheme),

                  const SizedBox(height: 40),
                  _buildSectionTitle(context, "03", "ORDER SUMMARY"),
                  const SizedBox(height: 15),
                  _buildOrderList(colorScheme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomBar(colorScheme),
        ],
      ),
    );
  }

  // --- UI COMPONENT METHODS ---

  Widget _buildSectionTitle(BuildContext context, String num, String title) {
    return Row(
      children: [
        Text(num, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, decoration: TextDecoration.underline)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildAddressDisplay(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.zero, // Minimalist fashion look
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DELIVERY TO:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.primary.withOpacity(0.5))),
          const SizedBox(height: 5),
          Text(
            _masterAddressController.text.isEmpty ? "No address selected yet." : _masterAddressController.text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap, bool isPrimary) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 45,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary ? colorScheme.onPrimary : colorScheme.primary,
          backgroundColor: isPrimary ? colorScheme.primary : Colors.transparent,
          side: BorderSide(color: colorScheme.primary),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }

  Widget _buildOrderList(ColorScheme colorScheme) {
    return Column(
      children: widget.selectedItems.map((item) {
        final price = item.product.price - (item.product.price * item.product.discount / 100);
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Container(
                height: 70, width: 60,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  image: DecorationImage(image: NetworkImage(item.product.imageUrl), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                    Text("Quantity: ${item.quantity}", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 11)),
                  ],
                ),
              ),
              Text("Rs. ${price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.onSurface.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w300)),
                Text("Rs. ${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: const Text("CONFIRM ORDER", style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPostalForm(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      color: colorScheme.secondary,
      child: Column(
        children: [
          CheckoutTextField(nameController: _townController, lable: "Town", icon: Icons.location_city),
          const SizedBox(height: 10),
          CheckoutTextField(nameController: _postalController, lable: "Postal Code", icon: Icons.local_post_office),
          const SizedBox(height: 10),
          CheckoutTextField(nameController: _districtController, lable: "District", icon: Icons.map),
          const SizedBox(height: 10),
          CheckoutTextField(nameController: _provinceController, lable: "Province", icon: Icons.explore),
          const SizedBox(height: 15),
          _buildActionButton(context, "APPLY ADDRESS", Icons.check_circle_outline, _applyPostalAddress, true),
        ],
      ),
    );
  }

  // --- LOGIC METHODS ---

  Future<void> _useGps() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Locating...'), duration: Duration(seconds: 1)));
    try {
      final address = await LocationService().getCurrentAddress();
      setState(() => _masterAddressController.text = address);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _applyPostalAddress() {
    if (_townController.text.isEmpty || _postalController.text.isEmpty) return;
    setState(() {
      _masterAddressController.text = "${_townController.text}, ${_districtController.text}, ${_provinceController.text} [${_postalController.text}]";
      showPostalFields = false;
    });
  }
}