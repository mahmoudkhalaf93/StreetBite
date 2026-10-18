/// SOLID PRINCIPLES: OPEN/CLOSED & SINGLE RESPONSIBILITY
/// PaymentStrategy defines a common interface for payments.
abstract class PaymentStrategy {
  Future<bool> processPayment(double amount);
  String get paymentMethodName;
}

/// Cash on delivery payment implementation
class CashPaymentService implements PaymentStrategy {
  @override
  String get paymentMethodName => 'Cash on Delivery';

  @override
  Future<bool> processPayment(double amount) async {
    // Simulated cash order confirmation
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

/// Credit/Debit card payment implementation
class CardPaymentService implements PaymentStrategy {
  final String cardNumber;

  CardPaymentService({required this.cardNumber});

  @override
  String get paymentMethodName => 'Credit Card ($cardNumber)';

  @override
  Future<bool> processPayment(double amount) async {
    // Simulated card gateway processing
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}
