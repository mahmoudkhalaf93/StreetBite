import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/payment_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/cart/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCash = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.navOrders,
          style: const TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocListener<CartCubit, CartState>(
        listenWhen: (previous, current) => previous.items.isNotEmpty && current.items.isEmpty,
        listener: (context, state) {
          if (state.orderSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.orderSuccessMessage!),
                backgroundColor: AppColors.primary,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cart is empty'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
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
                      'Add delicious meals from the home screen!',
                      style: TextStyle(fontFamily: 'SF Compact', color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item.meal.strMealThumb != null
                                  ? CachedNetworkImage(
                                      imageUrl: item.meal.strMealThumb!,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(width: 70, height: 70, color: Colors.grey.shade300),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.meal.strMeal,
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.pricePerItem.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontFamily: 'SF Compact',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 22, color: AppColors.primary),
                                  onPressed: () => context.read<CartCubit>().decrementQuantity(item.meal),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 22, color: AppColors.primary),
                                  onPressed: () => context.read<CartCubit>().addToCart(item.meal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Summary & Payment Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Payment Method Option
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Cash on Delivery'),
                              selected: _isCash,
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                color: _isCash ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                if (selected) setState(() => _isCash = true);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Credit Card'),
                              selected: !_isCash,
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                color: !_isCash ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                if (selected) setState(() => _isCash = false);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontFamily: 'SF Pro', fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            '\$${state.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontFamily: 'SF Pro', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: state.isPlacingOrder
                              ? null
                              : () async {
                                  final PaymentStrategy strategy = _isCash
                                      ? CashPaymentService()
                                      : CardPaymentService(cardNumber: '4242');

                                  await context.read<CartCubit>().placeOrder(strategy);
                                },
                          child: state.isPlacingOrder
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
