import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class PaymentInfoSheet extends StatefulWidget {
  const PaymentInfoSheet({super.key});

  @override
  State<PaymentInfoSheet> createState() => _PaymentInfoSheetState();
}

class _PaymentInfoSheetState extends State<PaymentInfoSheet> {
  final List<Map<String, String>> _cards = [
    {
      'holder': 'Vlad S.',
      'number': '•••• •••• •••• 4242',
      'expiry': '12/26',
      'type': 'VISA',
    },
  ];

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
            onPressed: () {
              if (numberController.text.isNotEmpty && holderController.text.isNotEmpty) {
                setState(() {
                  _cards.add({
                    'holder': holderController.text,
                    'number': '•••• •••• •••• ${numberController.text.length >= 4 ? numberController.text.substring(numberController.text.length - 4) : '0000'}',
                    'expiry': expiryController.text.isNotEmpty ? expiryController.text : '12/28',
                    'type': 'Mastercard',
                  });
                });
                Navigator.pop(ctx);
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
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                            card['type']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Icon(Icons.credit_card, color: Colors.white70),
                        ],
                      ),
                      Text(
                        card['number']!,
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
                                card['holder']!,
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
                                card['expiry']!,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
