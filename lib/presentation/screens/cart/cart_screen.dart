import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/payment_service.dart';
import '../../blocs/cart/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showCheckoutModal(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isCash = true;
    String selectedAddress = 'Park Way 145';
    String selectedCard = 'VISA •••• 4242';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Checkout Summary',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),

                Expanded(
                  child: ListView(
                    children: [
                      // 1. Select Delivery Address from Firestore
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (user != null)
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('addresses')
                              .snapshots(),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? [];
                            if (docs.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(selectedAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
                              );
                            }

                            return Column(
                              children: docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final addrName = data['addressEn'] ?? data['addressAr'] ?? 'Address';
                                final isSelected = selectedAddress == addrName;

                                return InkWell(
                                  onTap: () => setSheetState(() => selectedAddress = addrName),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.15)
                                          : (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100),
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: isSelected ? AppColors.primary : Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            addrName,
                                            style: TextStyle(
                                              fontFamily: 'SF Compact',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      const SizedBox(height: 20),

                      // 2. Select Payment Method
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Cash Option
                      InkWell(
                        onTap: () => setSheetState(() => isCash = true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isCash
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(12),
                            border: isCash ? Border.all(color: AppColors.primary, width: 1.5) : null,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.payments_outlined, color: isCash ? AppColors.primary : Colors.grey, size: 20),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Cash on Delivery',
                                  style: TextStyle(fontFamily: 'SF Compact', fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (isCash) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ),

                      // Card Option (Stream Cards from Firestore)
                      if (user != null)
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cards')
                              .snapshots(),
                          builder: (context, snapshot) {
                            final docs = snapshot.data?.docs ?? [];
                            if (docs.isEmpty) return const SizedBox();

                            return Column(
                              children: docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final cardInfo = '${data['type'] ?? 'Card'} ${data['number'] ?? '•••• 4242'}';
                                final isSelected = !isCash && selectedCard == cardInfo;

                                return InkWell(
                                  onTap: () => setSheetState(() {
                                    isCash = false;
                                    selectedCard = cardInfo;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.15)
                                          : (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100),
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.credit_card_rounded, color: isSelected ? AppColors.primary : Colors.grey, size: 20),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            cardInfo,
                                            style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);

                      final PaymentStrategy strategy = isCash
                          ? CashPaymentService()
                          : CardPaymentService(cardNumber: selectedCard);

                      final success = await context.read<CartCubit>().placeOrder(strategy);
                      if (success && context.mounted) {
                        Navigator.pop(context); // Close Cart screen and return to Orders
                      }
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<CartCubit, CartState>(
          listenWhen: (previous, current) => previous.items.isNotEmpty && current.items.isEmpty,
          listener: (context, state) {
            if (state.orderSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.orderSuccessMessage!),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          },
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Column(
                children: [
                  // 1. Top Bar with Delivery / Pickup Segmented Pill
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              height: 42,
                              width: 220,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F8F0),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => context.read<CartCubit>().setOrderType(isDelivery: true),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: state.isDelivery ? AppColors.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Delivery',
                                          style: TextStyle(
                                            fontFamily: 'SF Pro',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: state.isDelivery ? Colors.white : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => context.read<CartCubit>().setOrderType(isDelivery: false),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: !state.isDelivery ? AppColors.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Pickup',
                                          style: TextStyle(
                                            fontFamily: 'SF Pro',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: !state.isDelivery ? Colors.white : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Main Cart Content
                  Expanded(
                    child: state.items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'Your cart is empty',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add delicious meals to get started!',
                                  style: TextStyle(fontFamily: 'SF Compact', color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                // "Order" Header
                                Text(
                                  'Order',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Cart Items List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.items.length,
                                  itemBuilder: (context, index) {
                                    final item = state.items[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: item.meal.strMealThumb != null
                                                ? CachedNetworkImage(
                                                    imageUrl: item.meal.strMealThumb!,
                                                    width: 72,
                                                    height: 72,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(width: 72, height: 72, color: Colors.grey.shade300),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.meal.strMeal,
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '\$${item.pricePerItem.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Compact',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark ? Colors.white70 : const Color(0xFF1E1E1E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Quantity Pill Box (+, qty, -)
                                          Container(
                                            height: 38,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => context.read<CartCubit>().decrementQuantity(item.meal),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/delete_minus.svg',
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: TextStyle(
                                                      fontFamily: 'SF Pro',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => context.read<CartCubit>().addToCart(item.meal),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/plus.svg',
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                // "See menu" Button
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'See menu',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),

                                // Cost Breakdown
                                _buildCostRow('Order', '\$${state.itemsSubtotal.toStringAsFixed(2)}', isDark),
                                const SizedBox(height: 10),
                                _buildCostRow('Delivery fee', '\$${state.deliveryFee.toStringAsFixed(2)}', isDark),
                                const SizedBox(height: 10),
                                _buildCostRow('Fees & Taxes', '\$${state.taxes.toStringAsFixed(2)}', isDark),
                                const SizedBox(height: 10),
                                _buildCostRow('Discount', '-\$${state.discount.toStringAsFixed(2)}', isDark, isDiscount: true),
                                const SizedBox(height: 16),

                                // Subtotal / Final Total
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                      ),
                                    ),
                                    Text(
                                      '\$${state.finalTotal.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                              ],
                            ),
                          ),
                  ),

                  // Bottom Action Button "Checkout"
                  if (state.items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state.isPlacingOrder
                              ? null
                              : () => _showCheckoutModal(context),
                          child: state.isPlacingOrder
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String amount, bool isDark, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'SF Compact',
            fontSize: 15,
            color: isDiscount
                ? AppColors.primary
                : (isDark ? Colors.grey.shade400 : const Color(0xFF4B5563)),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'SF Compact',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? AppColors.primary
                : (isDark ? Colors.white : const Color(0xFF1E1E1E)),
          ),
        ),
      ],
    );
  }
}
