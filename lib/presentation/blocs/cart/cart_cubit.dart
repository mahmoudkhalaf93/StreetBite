import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/meal.dart';

class CartState extends Equatable {
  final List<Meal> cartItems;
  final double totalPrice;

  const CartState({this.cartItems = const [], this.totalPrice = 0.0});

  @override
  List<Object> get props => [cartItems, totalPrice];

  CartState copyWith({List<Meal>? cartItems, double? totalPrice}) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Meal meal) {
    final updatedCart = List<Meal>.from(state.cartItems)..add(meal);
    // Assuming each meal is roughly $15 for mockup logic
    final updatedPrice = state.totalPrice + 15.0; 
    emit(state.copyWith(cartItems: updatedCart, totalPrice: updatedPrice));
  }

  void removeFromCart(Meal meal) {
    final updatedCart = List<Meal>.from(state.cartItems)..remove(meal);
    final updatedPrice = state.totalPrice - 15.0;
    emit(state.copyWith(cartItems: updatedCart, totalPrice: updatedPrice < 0 ? 0 : updatedPrice));
  }

  void clearCart() {
    emit(const CartState());
  }
}
