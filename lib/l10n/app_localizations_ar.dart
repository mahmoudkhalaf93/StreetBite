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
  String get searchTitle => 'البحث';

  @override
  String get categoriesTitle => 'التصنيفات';

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

  @override
  String get pastOrders => 'الطلبات السابقة';

  @override
  String arrivesInMin(int min) {
    return 'يصل خلال $min دقيقة';
  }

  @override
  String itemsCount(int count) {
    return '$count وجبات';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String get recent => 'حديثاً';

  @override
  String get noOrdersYet => 'لا توجد طلبات سابقة بعد';

  @override
  String get pleaseSignInToViewOrders => 'يرجى تسجيل الدخول لمشاهدة طلباتك.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get paymentInfo => 'معلومات الدفع';

  @override
  String get addresses => 'العناوين';

  @override
  String get addAddress => 'إضافة عنوان جديد';

  @override
  String get defaultAddress => 'العنوان الافتراضي';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get supportPhone => 'خط الدعم الفني';

  @override
  String get sendMessage => 'إرسال رسالة';

  @override
  String get typeMessage => 'اكتب رسالتك...';

  @override
  String get faqTitle => 'الأسئلة الشائعة';

  @override
  String get cardHolder => 'حامل البطاقة';

  @override
  String get expires => 'تاريخ الانتهاء';

  @override
  String get addNewCard => 'إضافة بطاقة جديدة';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get fetchingLocation => 'جاري تحديد موقعك...';

  @override
  String get locationSaved => 'تم حفظ العنوان بنجاح';

  @override
  String get uploadingImage => 'جاري رفع الصورة...';

  @override
  String get imageUpdated => 'تم تحديث صورة الملف الشخصي';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط التعيين';

  @override
  String get resetEmailSent =>
      'تم إرسال رابط التعيين! يرجى التحقق من صندوق الوارد في بريدك الإلكتروني.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get changeDefaultAddressTitle => 'تغيير العنوان الافتراضي';

  @override
  String get changeDefaultAddressConfirm =>
      'هل توافق على تغيير العنوان الافتراضي إلى هذا العنوان؟';

  @override
  String get changeDefaultPaymentTitle => 'تغيير طريقة الدفع الأساسية';

  @override
  String get changeDefaultPaymentConfirm =>
      'هل توافق على تعيين هذه البطاقة كطريقة الدفع الأساسية؟';

  @override
  String get ingredients => 'المكونات';

  @override
  String get instructions => 'طريقة التحضير';

  @override
  String get noInstructions => 'لا توجد طريقة تحضير متوفرة.';

  @override
  String get price => 'السعر';

  @override
  String get agree => 'موافق';

  @override
  String get delivery => 'توصيل';

  @override
  String get pickup => 'استلام من الفرع';

  @override
  String get yourCartIsEmpty => 'سلة المشتريات فارغة';

  @override
  String get addDeliciousMeals => 'أضف وجبات شهية للبدء!';

  @override
  String get order => 'الطلب';

  @override
  String get seeMenu => 'تصفح القائمة';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get feesAndTaxes => 'الرسوم والضرائب';

  @override
  String get discount => 'الخصم';

  @override
  String get subtotal => 'المجموع الكلي';

  @override
  String get checkout => 'الدفع والتأكيد';

  @override
  String get checkoutSummary => 'ملخص الطلب والدفع';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get addNew => '+ إضافة جديد';

  @override
  String get noAddressFound =>
      'لم يتم العثور على عنوان! يرجى إضافة عنوان أعلاه.';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get selectAddressPrompt => 'يرجى اختيار أو إضافة عنوان توصيل أولاً!';

  @override
  String get activeOrderInProgressTitle => 'يوجد طلب جاري تنفيذه';

  @override
  String get activeOrderInProgressBody =>
      'لديك طلب جاري تحضيره حالياً! هل ترغب في عمل طلب إضافي آخر؟';

  @override
  String get viewCurrentOrder => 'عرض الطلب الحالي';

  @override
  String get placeAdditionalOrder => 'عمل طلب إضافي';

  @override
  String get orderPlacedSuccessfully => 'تم تقديم طلبك بنجاح! 🍕';

  @override
  String get cancel => 'إلغاء';
}
