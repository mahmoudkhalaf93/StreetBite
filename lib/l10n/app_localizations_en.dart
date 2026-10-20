// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StreetBite';

  @override
  String get foodAndGroceries => 'Food and groceries delivered to you';

  @override
  String get signInToGetMeal => 'Sign in to get your favorite meal ready';

  @override
  String get signUpTitle => 'Create an account';

  @override
  String get signUpSubtitle => 'Sign up to start discovering street food';

  @override
  String get fullName => 'Full Name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get nameRequired => 'Full Name is required';

  @override
  String get nameMustStartWithCapital =>
      'Name must start with a capital letter';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get underConstruction =>
      'This feature is currently in the development phase';

  @override
  String get parkWay => 'Park Way 145';

  @override
  String get searchTitle => 'Search';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get searchHint => 'Food, groceries, etc.';

  @override
  String get acclaimed => 'Acclaimed';

  @override
  String get healthy => 'Healthy';

  @override
  String get pizza => 'Pizza';

  @override
  String get ramen => 'Ramen';

  @override
  String get burger => 'Burger';

  @override
  String get fastest => 'Fastest';

  @override
  String get recommended => 'Recommended';

  @override
  String get min => 'min';

  @override
  String get km => 'km';

  @override
  String deliveryFeeText(Object amount, Object fee) {
    return '\$$fee delivery fee over \$$amount';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navBrowse => 'Browse';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get unknown => 'unknown';

  @override
  String get retry => 'Retry';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String addedToCart(String mealName) {
    return '$mealName added to cart';
  }

  @override
  String get hotOffers => 'Hot Offers';

  @override
  String get pastOrders => 'Past';

  @override
  String arrivesInMin(int min) {
    return 'Arrives in $min min';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get recent => 'Recent';

  @override
  String get noOrdersYet => 'No orders placed yet';

  @override
  String get pleaseSignInToViewOrders => 'Please sign in to view your orders.';

  @override
  String get settings => 'Settings';

  @override
  String get contactUs => 'Contact us';

  @override
  String get helpCenter => 'Help center';

  @override
  String get paymentInfo => 'Payment information';

  @override
  String get addresses => 'Addresses';

  @override
  String get addAddress => 'Add new address';

  @override
  String get defaultAddress => 'Default address';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get logout => 'Logout';

  @override
  String get supportPhone => 'Support Hotline';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get faqTitle => 'Frequently Asked Questions';

  @override
  String get cardHolder => 'Card Holder';

  @override
  String get expires => 'Expires';

  @override
  String get addNewCard => 'Add New Card';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String get locationSaved => 'Location saved successfully';

  @override
  String get uploadingImage => 'Uploading photo...';

  @override
  String get imageUpdated => 'Profile photo updated';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetEmailSent =>
      'Password reset link sent! Check your email inbox.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get changeDefaultAddressTitle => 'Change Default Address';

  @override
  String get changeDefaultAddressConfirm =>
      'Are you sure you want to set this as your default delivery address?';

  @override
  String get changeDefaultPaymentTitle => 'Change Primary Payment Method';

  @override
  String get changeDefaultPaymentConfirm =>
      'Are you sure you want to set this as your primary payment card?';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get instructions => 'Instructions';

  @override
  String get noInstructions => 'No instructions provided.';

  @override
  String get price => 'Price';

  @override
  String get agree => 'Agree';

  @override
  String get delivery => 'Delivery';

  @override
  String get pickup => 'Pickup';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get addDeliciousMeals => 'Add delicious meals to get started!';

  @override
  String get order => 'Order';

  @override
  String get seeMenu => 'See menu';

  @override
  String get deliveryFee => 'Delivery fee';

  @override
  String get feesAndTaxes => 'Fees & Taxes';

  @override
  String get discount => 'Discount';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get checkout => 'Checkout';

  @override
  String get checkoutSummary => 'Checkout Summary';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get addNew => '+ Add New';

  @override
  String get noAddressFound => 'No address found. Please add a location above!';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get selectAddressPrompt =>
      'Please add or select a delivery address first!';

  @override
  String get activeOrderInProgressTitle => 'Active Order in Progress';

  @override
  String get activeOrderInProgressBody =>
      'You already have an order currently being prepared! Would you like to place an additional order?';

  @override
  String get viewCurrentOrder => 'View Current Order';

  @override
  String get placeAdditionalOrder => 'Place Additional Order';

  @override
  String get orderPlacedSuccessfully => 'Order placed successfully! 🍕';

  @override
  String get cancel => 'Cancel';
}
