import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/meal.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/payment_service.dart';

class CartItem extends Equatable {
  final Meal meal;
  final int quantity;
  final double pricePerItem;

  const CartItem({
    required this.meal,
    this.quantity = 1,
    this.pricePerItem = 15.0,
  });

  double get totalPrice => quantity * pricePerItem;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      meal: meal,
      quantity: quantity ?? this.quantity,
      pricePerItem: pricePerItem,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': meal.idMeal,
      'strMeal': meal.strMeal,
      'strMealThumb': meal.strMealThumb,
      'strCategory': meal.strCategory,
      'strArea': meal.strArea,
      'quantity': quantity,
      'pricePerItem': pricePerItem,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      meal: MealModel(
        idMeal: json['idMeal'] ?? '',
        strMeal: json['strMeal'] ?? '',
        strMealThumb: json['strMealThumb'],
        strCategory: json['strCategory'],
        strArea: json['strArea'],
      ),
      quantity: json['quantity'] ?? 1,
      pricePerItem: (json['pricePerItem'] as num?)?.toDouble() ?? 15.0,
    );
  }

  @override
  List<Object?> get props => [meal, quantity, pricePerItem];
}

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isPlacingOrder;
  final String? orderSuccessMessage;

  const CartState({
    this.items = const [],
    this.isPlacingOrder = false,
    this.orderSuccessMessage,
  });

  double get totalPrice => items.fold(0.0, (acc, item) => acc + item.totalPrice);
  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);
  List<Meal> get cartItems => items.map((i) => i.meal).toList();

  @override
  List<Object?> get props => [items, isPlacingOrder, orderSuccessMessage];

  CartState copyWith({
    List<CartItem>? items,
    bool? isPlacingOrder,
    String? orderSuccessMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderSuccessMessage: orderSuccessMessage,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    loadCartFromFirestore();
  }

  Future<void> loadCartFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['cart'] != null) {
        final List rawCart = doc.data()!['cart'];
        final loadedItems = rawCart.map((item) => CartItem.fromJson(Map<String, dynamic>.from(item))).toList();
        emit(state.copyWith(items: loadedLoadedItems(loadedItems)));
      }
    } catch (_) {}
  }

  List<CartItem> loadedLoadedItems(List<CartItem> items) => items;

  Future<void> _syncCartToFirestore(List<CartItem> items) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final cartJson = items.map((i) => i.toJson()).toList();
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'cart': cartJson,
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  void addToCart(Meal meal) {
    final existingIndex = state.items.indexWhere((item) => item.meal.idMeal == meal.idMeal);
    List<CartItem> updatedItems = List.from(state.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      updatedItems.add(CartItem(meal: meal));
    }

    emit(state.copyWith(items: updatedItems, orderSuccessMessage: null));
    _syncCartToFirestore(updatedItems);
  }

  void decrementQuantity(Meal meal) {
    final existingIndex = state.items.indexWhere((item) => item.meal.idMeal == meal.idMeal);
    if (existingIndex < 0) return;

    List<CartItem> updatedItems = List.from(state.items);
    final existingItem = updatedItems[existingIndex];

    if (existingItem.quantity > 1) {
      updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity - 1);
    } else {
      updatedItems.removeAt(existingIndex);
    }

    emit(state.copyWith(items: updatedItems, orderSuccessMessage: null));
    _syncCartToFirestore(updatedItems);
  }

  void removeFromCart(Meal meal) {
    final updatedItems = state.items.where((item) => item.meal.idMeal != meal.idMeal).toList();
    emit(state.copyWith(items: updatedItems, orderSuccessMessage: null));
    _syncCartToFirestore(updatedItems);
  }

  void clearCart() {
    emit(const CartState());
    _syncCartToFirestore([]);
  }

  Future<bool> placeOrder(PaymentStrategy paymentStrategy) async {
    if (state.items.isEmpty) return false;

    emit(state.copyWith(isPlacingOrder: true, orderSuccessMessage: null));

    try {
      final success = await paymentStrategy.processPayment(state.totalPrice);
      if (!success) {
        emit(state.copyWith(isPlacingOrder: false));
        return false;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final orderData = {
          'items': state.items.map((item) => {
            'idMeal': item.meal.idMeal,
            'strMeal': item.meal.strMeal,
            'strMealThumb': item.meal.strMealThumb,
            'quantity': item.quantity,
            'pricePerItem': item.pricePerItem,
            'totalPrice': item.totalPrice,
          }).toList(),
          'totalAmount': state.totalPrice,
          'itemCount': state.totalItemCount,
          'paymentMethod': paymentStrategy.paymentMethodName,
          'status': 'Preparing',
          'createdAt': FieldValue.serverTimestamp(),
        };

        // 1. Save order to user's orders collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .add(orderData);

        // 2. Clear cart in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'cart': [],
        }, SetOptions(merge: true));
      }

      emit(const CartState(
        items: [],
        isPlacingOrder: false,
        orderSuccessMessage: 'Order placed successfully!',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(isPlacingOrder: false));
      return false;
    }
  }
}
