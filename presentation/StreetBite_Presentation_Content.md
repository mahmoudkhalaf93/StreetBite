# StreetBite V1.0 - Graduation Presentation Content

*Instructions: Copy this content slide by slide into PowerPoint, Canva, or Google Slides. Add the screenshots mentioned.*

---

### Slide 1: Title Slide
- **Title:** StreetBite V1.0
- **Subtitle:** Flutter Food Discovery & Ordering App — Graduation Capstone Project
- **Visual:** StreetBite App Logo (`assets/icons/appicon.png` or `assets/images/applogofastfood.png`)
- **Footer:** Mahmoud Khalaf — Senior Flutter Engineer & Software Architect

---

### Slide 2: Problem Statement & Goals
- **Title:** Project Goals & Vision
- **Content:**
  - Build a responsive, bilingual (English & Arabic) food discovery and ordering mobile application.
  - Implement strict Clean Architecture (Data, Domain, Presentation) with 4 documented design patterns.
  - Integrate live REST APIs (TheMealDB) and Cloud Firestore for reactive real-time data persistence.
  - Deliver a production-ready APK via Firebase App Distribution and App Tester.
- **Visual:** Side-by-side screenshots: `home_light_arabic_(2).jpg` and `home_screen_dark_.jpg`.

---

### Slide 3: Development & DevOps Workflow
- **Title:** Agile & DevOps Workflow
- **Content:**
  - **Version Control:** GitHub for repository management, branches, and security checks.
  - **QA & Automation:** Jira for bug tracking, Appium + Java TestNG for UI automation.
  - **Beta Distribution:** Firebase App Distribution for tester delivery and feedback.
- **Visual:** Flowchart arrows: `Code (Flutter)` ➔ `Test (Appium/QA)` ➔ `Deploy (Firebase App Distribution)` + Screenshot: `firebase_dashboard.png` & `test_app.jpg`.

---

### Slide 4: Technologies & Architecture
- **Title:** Tech Stack & Clean Architecture
- **Content:**
  - **Framework:** Flutter & Dart (Material 3)
  - **State Management:** flutter_bloc (Cubit)
  - **Dependency Injection:** GetIt (Service Locator)
  - **Networking & Cache:** Dio + SharedPreferences (Stale-While-Revalidate pattern)
  - **Backend:** Firebase Auth, Firestore, Storage
  - **Design Patterns:** Builder (`UserModelBuilder`), Factory (`MealDataSourceFactory`), Singleton (`FirestoreService`), Strategy (`PaymentStrategy`).
- **Visual:** Standard 3-layer Clean Architecture diagram (Presentation ➔ Domain ➔ Data).

---

### Slide 5: Features — Home Screen & Performance
- **Title:** Dynamic Home Screen & True Lazy Loading
- **Content:**
  - Fetches 14 real food categories and live meals from TheMealDB.
  - Implements True Lazy Loading using `CustomScrollView` and `Slivers` (`SliverGrid`, `SliverList`).
  - Memory bounds with `CachedNetworkImage` (`memCacheWidth: 400`) preventing RAM spikes during fast scrolling.
- **Visual:** Screenshots: `home_light.jpg`, `home_light_arabic_(2).jpg`, and `home_screen_dark_.jpg`.

---

### Slide 6: Features — Search & Category Filters
- **Title:** Live Search & Category Filtering
- **Content:**
  - Real-time instant search by dish or ingredient name (e.g. Pizza, Burger).
  - Category-specific meal feeds for Beef, Vegetarian, Dessert, Pasta, and Miscellaneous dishes.
  - Country/Area filtering (Italian, Egyptian, Asian, Middle Eastern).
- **Visual:** Screenshots: `cat_miscellaneous_light.jpg`, `category_arabic_light.jpg`, and `dessert_cat_dark.jpg`.

---

### Slide 7: Features — Meal Details & Ingredients
- **Title:** Meal Details & Preparation Instructions
- **Content:**
  - Full-resolution cover imagery with rating badges and price tags.
  - Localized wrap list of ingredients and preparation measures.
  - Full preparation instructions translated for Arabic RTL and English LTR layouts.
- **Visual:** Screenshots: `details_page_english_light1.jpg`, `details_page_arabic_light1.jpg`, and `details_page_english_dark1.jpg`.

---

### Slide 8: Features — Cart & Geolocated Checkout
- **Title:** Reactive Cart & Smart Checkout Modal
- **Content:**
  - Dynamic Subtotal, Delivery Fee, Taxes, and Discount calculation engine.
  - GPS address picker via `geolocator` with a **150-meter duplicate address guard**.
  - Open/Closed Payment Strategy accepting Cash on Delivery and Saved Credit Cards.
- **Visual:** Screenshots: `cart_pickup_light.jpg`, `cart_arabic_light.jpg`, and `check_out_arabic_light.jpg`.

---

### Slide 9: Features — Active Orders & Live Countdown
- **Title:** Real-Time Orders & Delivery Countdown
- **Content:**
  - Calculates a live 30-minute delivery countdown timer based on the exact `placedAtMillis` timestamp.
  - Zero-flicker UI updates without rebuilding the main screen scaffold.
  - Automatic lifecycle transition from **Active Orders** (`Arrives in X min`) to **Past Orders** history.
- **Visual:** Screenshots: `orders_light.jpg`, `orders_arabic_light.jpg`, and `orders_dark.jpg`.

---

### Slide 10: Features — Profile, Location & Biometric Security
- **Title:** Profile Management, Geolocation & Biometric Guard
- **Content:**
  - User avatar upload from phone gallery directly to Firebase Storage.
  - Device info display (`device_info_plus`) showing device model and Android OS version.
  - GPS Geolocation address fetch (`get_location_from_profile_dark.jpg`, `fetching_location.jpg`).
  - Biometric fingerprint login (`local_auth`) securely enabled per User `UID` (`enable_biometric_to_login.jpg`).
- **Visual:** Screenshots: `profile_arabic_light.jpg`, `profile_enabled_biometric_to_login_dark.jpg`, `get_location_from_profile_dark.jpg`, and `login_with_fingerprint.jpg`.

---

### Slide 11: Features — Google Maps Vendor Discovery
- **Title:** Nearby Vendor Discovery Map
- **Content:**
  - Interactive Google Maps (`google_maps_flutter`) showing 5 nearby food vendor pins.
  - Custom styled markers and InfoWindow bottom sheets displaying ratings and cuisines.
- **Visual:** Screenshots: `nearby_vendors.jpg`, `nearby_vendor_light_arabic.jpg`, and `nearby_vendors_pop_up_dialog_dark.jpg`.

---

### Slide 12: Testing Strategy & Automation
- **Title:** QA Strategy & Appium Java Automation
- **Content:**
  - Complete Manual Test Plan, Test Cases, Traceability Matrix, and Test Closure Summary in `docs/qa/`.
  - **Appium Java TestNG Suite:** Automated scripts in `qa_automation/` covering Login validation and W3C Home gesture scrolling.
  - 100% Passing Rate across all critical functional requirements.
- **Visual:** Screenshot: `qa_arabic_light.jpg` and TestNG execution report.

---

### Slide 13: Conclusion & Future Scope
- **Title:** Conclusion & Future Roadmap
- **Content:**
  - Successfully delivered a production-ready, clean-architecture Flutter application.
  - Fully bilingual (EN/AR), highly optimized for memory and scrolling, and tested via Firebase.
  - **Future Roadmap:** Payment gateway live integration (Paymob/Stripe), Push Notifications, and Driver Live GPS Tracking.
- **Footer:** Thank You! Q&A.
