# 🍔 StreetBite V1.0 — Flutter Food Discovery & Ordering App

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20BLoC-00C874?style=for-the-badge)](https://bloclibrary.dev/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**StreetBite V1.0** is a full-featured, bilingual (English & Arabic) food discovery and ordering mobile application built with **Flutter**, **Clean Architecture**, **TheMealDB REST API**, and **Firebase Cloud Services**.

---

## 📱 Complete App Showcase (Side-by-Side Screen Triplets)

Every screen is presented in three synchronized variations: **Light Mode (English)**, **Light Mode (Arabic RTL)**, and **Dark Mode (English)**.

### 1. 🚀 Splash & Authentication Flow

#### Splash & Login Options
> Extended elastic logo animation, Email/Password, Google Sign-In, and Password Reset.
<div align="center">

| Splash Screen | Login Screen (English) | Sign Up / Create Account | Password Reset |
| :---: | :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/splash_screen.jpg" width="220"/> | <img src="docs/final_submission/evidence/app_screenshots/login.jpg" width="220"/> | <img src="docs/final_submission/evidence/app_screenshots/create_account.jpg" width="220"/> | <img src="docs/final_submission/evidence/app_screenshots/reset_password.jpg" width="220"/> |

</div>

#### Biometric Fingerprint Login (`local_auth`)
> Native fingerprint prompt securely mapped to the specific user's UID for instant biometric login.
<div align="center">

| Fingerprint Prompt | Biometric Authenticated Session |
| :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/login_with_fingerprint.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/sign_in_to_your_account_with_fingerprint.jpg" width="260"/> |

</div>

---

### 2. 🏠 Home Screen (Feeds & Offers)
> Dynamic header with geolocated address, auto-sliding banner offers with localized discount badges, categories carousel, fastest near you, and recommended meals grid with lazy loading.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/home_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/home_light_arabic_(2).jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/home_screen_dark_.jpg" width="260"/> |

</div>

---

### 3. 🔍 Browse & Search Categories
> 14 live food categories matching TheMealDB API with real-time instant search bar.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/browse_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/browse_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/browse_screen_dark.jpg" width="260"/> |

</div>

---

### 4. 🍕 Category Meals Filter
> Category-specific meal feeds filtered by food type (Miscellaneous, Beef, Vegetarian, Dessert, etc.).

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/cat_miscellaneous_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/category_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/dessert_cat_dark.jpg" width="260"/> |

</div>

---

### 5. 🔍 Live Dish Search (Pizza, Vegetarian)
> Live search query results with instant API response filtering.

<div align="center">

| Search Light (Pizza) | Search Arabic (Vegetarian) | Search Dark (Pizza) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/search_pizza_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/veg_cat_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/search_pizza_dark.jpg" width="260"/> |

</div>

---

### 6. 🍲 Meal Details Page
> High-resolution cover photo, ratings, price, localized ingredients wrap list, and preparation instructions.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/details_page_english_light1.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/details_page_arabic_light1.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/details_page_english_dark1.jpg" width="260"/> |

</div>

---

### 7. 🛒 Cart Screen & Delivery Selector
> Interactive quantity pill box, Delivery vs. Pickup segmented selector, and cost breakdown (Subtotal, Delivery Fee, Taxes, Discount).

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/cart_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/cart_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/cart_dark.jpg" width="260"/> |

</div>

---

### 8. 💳 Checkout Sheet Modal
> Delivery address selector with GPS location fetch, 150-meter duplicate address guard, and Cash on Delivery / Card payment strategy options.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/checkout_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/check_out_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/check_out_dark.jpg" width="260"/> |

</div>

---

### 9. ⏱️ Orders Screen & Live Countdown Timer
> Active 30-minute delivery countdown timer calculated from exact `placedAtMillis` timestamp, automatically transitioning to Past Orders history once time elapses.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/orders_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/orders_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/orders_dark.jpg" width="260"/> |

</div>

---

### 10. ❤️ Favourites Screen
> Synchronized live with `users/{uid}/favourites` in Cloud Firestore with instant remove and add-to-cart actions.

<div align="center">

| Favourites Screen (Dark Mode) | Favourites Toggle Action |
| :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/my_favourites_dark.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/goat_add_to_favourites_dark.jpg" width="260"/> |

</div>

---

### 11. 👤 Profile & Settings Screen
> User avatar upload to Firebase Storage, device model & OS details via `device_info_plus`, Biometric toggle, language dropdown, and theme switch.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode (English) |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/profile_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/profile_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/profile_dark.jpg" width="260"/> |

</div>

---

### 12. 💬 Support, FAQ & Payment Information Sheets
> Support hotline chat interface, FAQ accordion, and saved credit card manager.

<div align="center">

| Contact Support Chat (Arabic) | Contact Support Chat (Dark) | FAQ Help Center Sheet |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/connect_us_arabic_light.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/contact_us_dark.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/faq_dark.jpg" width="260"/> |

</div>

---

### 13. 🗺️ Google Maps Vendor Discovery
> Interactive Google Maps with 5 nearby food vendor pins and custom InfoWindow bottom sheets showing ratings and cuisines.

<div align="center">

| Light Mode (English) | Light Mode (Arabic RTL) | Dark Mode Vendor Sheet |
| :---: | :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/nearby_vendors.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/nearby_vendor_light_arabic.jpg" width="260"/> | <img src="docs/final_submission/evidence/app_screenshots/nearby_vendors_pop_up_dialog_dark.jpg" width="260"/> |

</div>

---

### 14. 🧪 Beta Testing & Firebase App Distribution
> Release APK distributed and tested via Firebase App Distribution Console & App Tester mobile app.

<div align="center">

| App Tester Mobile App | Firebase Console Distribution Dashboard |
| :---: | :---: |
| <img src="docs/final_submission/evidence/app_screenshots/test_app.jpg" width="280" alt="App Tester"/> | <img src="docs/final_submission/evidence/firebase_distribution/firebase_dashboard.png" width="460" alt="Firebase Dashboard"/> |

</div>

---

## ⚡ Complete Feature Matrix & Capabilities

### 🔐 1. Authentication & Session Security
- **Multi-Factor Auth Flow:** Email/Password Authentication, Google Sign-In, Sign-Up with name validation, and Password Reset email link dispatch.
- **Persistent Session State:** Automatic auto-login session restoration via Firebase Auth.
- **Biometric Hardware Guard (`local_auth`):** Fingerprint/FaceID login capability stored securely per User `UID` in `SharedPreferences`.

### 🍕 2. Live REST API & Smart Caching
- **TheMealDB API Client:** Live HTTP fetching via `Dio` for 14 real API categories, random selection, and meal details.
- **Stale-While-Revalidate Caching:** Dual-layer local persistence via `SharedPreferences` allowing instant offline viewing of previously loaded meals.

### 🚀 3. True Lazy Loading & Memory Optimization
- **Sliver Grid Architecture:** `HomeScreen`, `CategoryMealsScreen`, and `OrdersScreen` use `CustomScrollView` and `Slivers` (`SliverGrid`, `SliverList`) for 100% lazy loading.
- **RAM Image Optimization:** All remote network images use `CachedNetworkImage` with `memCacheWidth: 400` / `200` to prevent memory leaks or frame drops during fast scrolling.
- **Zero-Flicker Live Timers:** Order countdown timers update without rebuilding the main screen scaffold.

### 🛒 4. Reactive Cart & Geolocated Checkout
- **Dynamic Calculation Engine:** Real-time Subtotal, Delivery Fee, Taxes, and Discount calculation via `CartCubit`.
- **Address GPS & Proximity Check:** Integrates `geolocator` and `geocoding` for live location fetching with a **150-meter duplicate address check**.
- **SOLID Payment Gateways:** Checkout accepts Cash on Delivery and Saved Cards utilizing the Open/Closed Strategy Pattern (`PaymentStrategy`).

### ⏱️ 5. Orders Management & Live Countdown
- **Dynamic Order Classifier:** Orders calculate an exact 30-minute delivery window based on the `placedAtMillis` timestamp.
- **Automated Lifecycle:** Active orders automatically transition to **Past Orders** once the delivery time window elapses.

### ❤️ 6. Favourites & Cloud Synchronization
- **Firestore Persistence:** Heart toggles on cards and details screens sync live with `users/{uid}/favourites` in Cloud Firestore.

### 🗺️ 7. Vendor Discovery Map
- **Google Maps (`google_maps_flutter`):** Interactive map showing 5 nearby food vendor pins with custom InfoWindows displaying ratings and cuisines.

### 🌐 8. Localization & Dynamic Themes
- **Full EN/AR Localization:** Complete English and Arabic translations using ARB files with automatic RTL (Right-To-Left) layout mirroring.
- **Light/Dark Mode Engine:** Dynamic theme switching maintained globally across screens.

### 📱 9. Profile & Hardware Integration
- **Device Info (`device_info_plus`):** Displays user's specific device model and OS version.
- **Avatar Upload (`image_picker`):** Profile picture update from phone gallery uploaded to Firebase Storage.

---

## 🏗 Architecture & Design Patterns

```
lib/
├── core/                  # Theme, Errors, Failures, UseCases
├── data/
│   ├── datasources/       # Remote (Dio/Firebase) & Local (SharedPreferences)
│   ├── models/            # JSON Models & Serializers
│   ├── repositories/      # Repository Implementations
│   └── services/          # Singleton & Payment Strategy Services
├── domain/
│   ├── entities/          # Pure Business Entities
│   ├── repositories/      # Repository Interfaces
│   └── usecases/          # Business Logic Use Cases
├── presentation/
│   ├── blocs/             # Cubits (Auth, Cart, Meal, Theme, Locale)
│   ├── screens/           # UI Screens (Home, Cart, Orders, Profile, etc.)
│   └── widgets/           # Reusable UI Components
├── l10n/                  # app_en.arb & app_ar.arb
└── injection.dart         # GetIt Service Locator Registration
```

### Documented Design Patterns
1. **Builder Pattern:** `UserModelBuilder` (`lib/data/models/user_model.dart`) for entity construction.
2. **Factory Pattern:** `MealDataSourceFactory` (`lib/data/repositories/meal_repository_impl.dart`) for remote vs. local cache switching.
3. **Singleton Pattern:** `FirestoreService` (`lib/data/services/firestore_service.dart`) for global database access.
4. **Strategy Pattern (SOLID):** `PaymentStrategy`, `CashPaymentService`, and `CardPaymentService` (`lib/data/services/payment_service.dart`).

---

## 🧪 Quality Assurance & Automation

- **Manual QA Documents:** Located in `docs/qa/` (Test Plan, Test Cases CSVs, Traceability Matrix, Test Closure Summary, Jira Bug Templates).
- **Appium Java Automation:** Located in `qa_automation/` (Maven project with TestNG, `BaseTest`, `LoginTest`, and `HomeTest` using W3C gesture actions).

---

## 🚀 Build & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mahmoudkhalaf93/StreetBite.git
   cd streetbite
   ```

2. **Install Dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```

---

## 👤 Developer & Acknowledgments

**Mahmoud Khalaf**  
*Senior Flutter Engineer & Software Architect*  
Graduation Capstone Project — **StreetBite V1.0**
