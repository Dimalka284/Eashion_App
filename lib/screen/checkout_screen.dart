import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/provider/cart_provider.dart';
import 'package:eashion2/provider/checkout_provider.dart';
import 'package:eashion2/screen/home_screen.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:eashion2/widgets/checkout_Text_field.dart';
import 'package:eashion2/widgets/location_action_btn.dart';
import 'package:eashion2/widgets/manual_address_form.dart';
import 'package:eashion2/widgets/order_list.dart';
import 'package:eashion2/widgets/order_total_footer.dart';
import 'package:eashion2/widgets/shipping_address_card.dart';
import 'package:eashion2/widgets/step_section_header.dart';
import 'package:flutter/material.dart';
import 'package:eashion2/services/location_service.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;
  const CheckoutScreen({super.key, required this.selectedItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _masterAddressController =
      TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();

  bool showPostalFields = false;

  // Calculate Total Price
  double get totalAmount {
    return widget.selectedItems.fold(0, (sum, item) {
      final discountedPrice =
          item.product.price -
          (item.product.price * item.product.discount / 100);
      return sum + (discountedPrice * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
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
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
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
                  StepSectionHeader(
                    context: context,
                    num: "01",
                    title: "SHIPPING DETAILS",
                  ),
                  const SizedBox(height: 20),
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
                  StepSectionHeader(
                    context: context,
                    num: "02",
                    title: "DESTINATION",
                  ),
                  const SizedBox(height: 15),
                  ShippingAddressCard(
                    masterAddressController: _masterAddressController,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: LocationActionButton(
                          context: context,
                          label: "GPS LOCATE",
                          icon: Icons.my_location,
                          onTap: _useGps,
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LocationActionButton(
                          context: context,
                          label: "POSTAL",
                          icon: Icons.edit_location_alt_outlined,
                          onTap: () {
                            setState(
                              () => showPostalFields = !showPostalFields,
                            );
                          },
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),

                  if (showPostalFields)
                    ManualAddressForm(
                      townController: _townController,
                      postalController: _postalController,
                      districtController: _districtController,
                      provinceController: _provinceController,
                      onApply: _applyPostalAddress,
                    ),
                  const SizedBox(height: 40),
                  StepSectionHeader(
                    context: context,
                    num: "03",
                    title: "ORDER SUMMARY",
                  ),
                  const SizedBox(height: 15),
                  OrderList(widget: widget, colorScheme: colorScheme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          OrderTotalFooter(
            totalAmount: totalAmount,
            onConfirm: _handleOrderConfirmation,
          ),
        ],
      ),
    );
  }

  void _handleOrderConfirmation() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter your Full Name");
      return;
    }
    if (_numberController.text.trim().length < 9) {
      _showErrorSnackBar("Please enter a valid Phone Number");
      return;
    }
    if (_masterAddressController.text.isEmpty ||
        _masterAddressController.text == "No address selected yet.") {
      _showErrorSnackBar(
        "Please provide a Delivery Address via GPS or Postal form",
      );
      return;
    }

    final String? token = await UserSessionService().getToken();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final checkoutProvider = Provider.of<CheckoutProvider>(
      context,
      listen: false,
    );

    // Execute the clear logic
    await checkoutProvider.placeOrderAndClearCart(
      token: token!,
      itemsToClear: widget.selectedItems,
      allCartItems: cartProvider.items,
    );

    _showSuccessDialog();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 60,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "ORDER PLACED!",
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Thank you, ${_nameController.text}. Your fashion haul is on its way!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: const Text(
              "BACK TO SHOPPING",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useGps() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Locating...'),
        duration: Duration(seconds: 1),
      ),
    );
    try {
      final address = await LocationService().getCurrentAddress();
      setState(() => _masterAddressController.text = address);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _applyPostalAddress() {
    if (_townController.text.isEmpty || _postalController.text.isEmpty) return;
    setState(() {
      _masterAddressController.text =
          "${_townController.text}, ${_districtController.text}, ${_provinceController.text} [${_postalController.text}]";
      showPostalFields = false;
    });
  }
}
