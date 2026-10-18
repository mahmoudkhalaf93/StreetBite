import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'Recent';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0 && now.day == date.day) {
      return 'Today';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != date.day)) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Please sign in to view your orders."))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('orders')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            l10n.navOrders,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No orders placed yet',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Separate Active Orders from Past Orders
                  final activeOrders = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'Preparing';
                    return status == 'Preparing' || status == 'On the way';
                  }).toList();

                  final pastOrders = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'Preparing';
                    return status != 'Preparing' && status != 'On the way';
                  }).toList();

                  // If no explicitly finished orders, treat all except the top 1 as past for design preview
                  List<QueryDocumentSnapshot> displayActive = activeOrders;
                  List<QueryDocumentSnapshot> displayPast = pastOrders;

                  if (displayActive.isEmpty && docs.isNotEmpty) {
                    displayActive = [docs.first];
                    displayPast = docs.sublist(1);
                  } else if (displayActive.isNotEmpty && displayPast.isEmpty && docs.length > 1) {
                    displayPast = docs.sublist(1);
                    displayActive = [docs.first];
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // 1. "Orders" Header
                        Text(
                          l10n.navOrders,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2. Active Orders Section
                        if (displayActive.isNotEmpty) ...[
                          ...displayActive.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final items = (data['items'] as List?) ?? [];
                            final firstItem = items.isNotEmpty ? items.first : {};
                            final title = firstItem['strMeal'] ?? 'StreetBite Special';
                            final thumb = firstItem['strMealThumb'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: thumb != null
                                        ? CachedNetworkImage(
                                            imageUrl: thumb,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(width: 90, height: 90, color: Colors.grey.shade300),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Arrives in 25-30 min',
                                              style: TextStyle(
                                                fontFamily: 'SF Pro',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontFamily: 'SF Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],

                        // 3. Past Orders Section Header
                        if (displayPast.isNotEmpty) ...[
                          Text(
                            'Past',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Past Orders List
                          ...displayPast.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final items = (data['items'] as List?) ?? [];
                            final firstItem = items.isNotEmpty ? items.first : {};
                            final title = firstItem['strMeal'] ?? 'StreetBite Meal';
                            final thumb = firstItem['strMealThumb'];
                            final itemCount = (data['itemCount'] as num?)?.toInt() ?? items.length;
                            final timestamp = (data['createdAt'] as Timestamp?)?.toDate();
                            final timeAgo = _formatTimeAgo(timestamp);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: thumb != null
                                        ? CachedNetworkImage(
                                            imageUrl: thumb,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(width: 80, height: 80, color: Colors.grey.shade300),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
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
                                          '$itemCount items  •  $timeAgo',
                                          style: const TextStyle(
                                            fontFamily: 'SF Compact',
                                            fontSize: 14,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
