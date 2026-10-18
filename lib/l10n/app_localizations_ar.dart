// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ستريت بايت';

  @override
  String get foodAndGroceries => 'طعامك ومقاضيك تصل إليك';

  @override
  String get signInToGetMeal => 'سجل دخولك لتجهيز وجبتك المفضلة';

  @override
  String get signUpTitle => 'إنشاء حساب جديد';

  @override
  String get signUpSubtitle => 'سجل الآن وابدأ في استكشاف الطعام';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام جوجل';

  @override
  String get continueWithFacebook => 'المتابعة باستخدام فيسبوك';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get nameRequired => 'الاسم الكامل مطلوب';

  @override
  String get nameMustStartWithCapital =>
      'يجب أن يبدأ الاسم بحرف كبير (Capital)';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور يجب أن لا تقل عن 6 أحرف';

  @override
  String get confirmPasswordRequired => 'الرجاء تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get underConstruction => 'هذه الميزة قيد التطوير والبرمجة حالياً';

  @override
  String get parkWay => 'بارك واي 145';

  @override
  String get searchHint => 'طعام، بقالة، إلخ...';

  @override
  String get acclaimed => 'مشهور';

  @override
  String get healthy => 'صحي';

  @override
  String get pizza => 'بيتزا';

  @override
  String get ramen => 'رامن';

  @override
  String get burger => 'برجر';

  @override
  String get fastest => 'الأسرع';

  @override
  String get recommended => 'موصى به';

  @override
  String get min => 'دقيقة';

  @override
  String get km => 'كم';

  @override
  String deliveryFeeText(Object amount, Object fee) {
    return 'رسوم توصيل \$$fee للطلبات فوق \$$amount';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navBrowse => 'تصفح';

  @override
  String get navOrders => 'الطلبات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get unknown => 'غير معروف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get addToCart => 'أضف للسلة';

  @override
  String addedToCart(String mealName) {
    return 'تم إضافة $mealName إلى السلة';
  }

  @override
  String get hotOffers => 'عروض مميزة';
}
