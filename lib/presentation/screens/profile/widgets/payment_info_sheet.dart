import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class PaymentInfoSheet extends StatefulWidget {
  const PaymentInfoSheet({super.key});

  @override
  State<PaymentInfoSheet> createState() => _PaymentInfoSheetState();
}

class _PaymentInfoSheetState extends State<PaymentInfoSheet> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _seedDefaultCardIfEmpty();
  }

  Future<void> _seedDefaultCardIfEmpty() async {
    if (user == null) return;
    final cardsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cards');

    final snapshot = await cardsRef.get();
    if (snapshot.docs.isEmpty) {
      await cardsRef.add({
        'holder': user!.displayName?.isNotEmpty == true ? user!.displayName : 'Vlad S.',
        'number': '•••• •••• •••• 4242',
        'expiry': '12/26',
        'type': 'VISA',
        'isDefault': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _setDefaultCard(String selectedDocId) async {
    if (user == null) return;
    final cardsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cards');

    final snapshot = await cardsRef.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == selectedDocId});
    }

    await batch.commit();
  }

  void _confirmSetDefaultCard(String docId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.changeDefaultPaymentTitle,
          style: const TextStyle(fontFamily: 'SF Pro', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.changeDefaultPaymentConfirm,
          style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.pop(ctx);
              await _setDefaultCard(docId);
            },
            child: Text(l10n.agree, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final numberController = TextEditingController();
    final holderController = TextEditingController();
    final expiryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.addNewCard,
          style: const TextStyle(fontFamily: 'SF Pro', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: holderController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.cardHolder,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.cardNumber,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: expiryController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.expires,
                hintText: 'MM/YY',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (numberController.text.isNotEmpty && holderController.text.isNotEmpty && user != null) {
                final last4 = numberController.text.length >= 4
                    ? numberController.text.substring(numberController.text.length - 4)
                    : '0000';

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('cards')
                    .add({
                  'holder': holderController.text,
                  'number': '•••• •••• •••• $last4',
                  'expiry': expiryController.text.isNotEmpty ? expiryController.text : '12/28',
                  'type': 'Mastercard',
                  'isDefault': false,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                if (mounted && ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save Card', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.paymentInfo,
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: user == null
                ? const Center(child: Text("Please sign in to view cards"))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('cards')
                        .orderBy('createdAt', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }

                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Center(child: Text("No cards found"));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final holder = data['holder'] ?? 'Vlad S.';
                          final number = data['number'] ?? '•••• •••• •••• 4242';
                          final expiry = data['expiry'] ?? '12/26';
                          final type = data['type'] ?? 'VISA';
                          final isDefault = data['isDefault'] == true;

                          return GestureDetector(
                            onTap: isDefault ? null : () => _confirmSetDefaultCard(doc.id),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: isDefault
                                    ? Border.all(color: AppColors.primary, width: 3)
                                    : null,
                                gradient: LinearGradient(
                                  colors: index % 2 == 0
                                      ? [const Color(0xFF1E1E1E), const Color(0xFF3A3A3A)]
                                      : [AppColors.primary, const Color(0xFF009657)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        type,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      if (isDefault)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.check_circle, color: Colors.white, size: 14),
                                              SizedBox(width: 4),
                                              Text(
                                                'PRIMARY',
                                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        const Icon(Icons.credit_card, color: Colors.white70),
                                    ],
                                  ),
                                  Text(
                                    number,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 2,
                                      fontFamily: 'SF Pro',
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.cardHolder.toUpperCase(),
                                            style: const TextStyle(color: Colors.white60, fontSize: 10),
                                          ),
                                          Text(
                                            holder,
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.expires.toUpperCase(),
                                            style: const TextStyle(color: Colors.white60, fontSize: 10),
                                          ),
                                          Text(
                                            expiry,
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addNewCard, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: _showAddCardDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
