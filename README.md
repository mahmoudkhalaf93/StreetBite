# 🍔 StreetBite V1.0 — Flutter Food Discovery & Ordering App

**StreetBite V1.0** is a full-featured, bilingual (English & Arabic) food discovery and ordering application developed as a graduation capstone project. Built using **Flutter** and strict **Clean Architecture** principles, the app integrates live REST APIs, Firebase services, and native device capabilities to deliver a smooth and scalable user experience.

---

## ✨ Key Features & Highlights
- **Clean Architecture & Design Patterns:** Layered structure (Data, Domain, Presentation) utilizing BLoC/Cubit, GetIt DI, Builder (UserModel), Factory (MealRepository for Cache vs API), and Singleton (Firestore service).
- **Authentication & Persistence:** Secure Email/Password & Google Sign-In with persistent sessions via Firebase Authentication.
- **Biometric Security:** Fingerprint authentication via `local_auth` directly mapped to User IDs in `SharedPreferences`.
- **Live Menu & Caching:** Real-time meal fetching from TheMealDB API via Dio, combined with Double-Layer caching (Data & Images) for instant offline loading and zero jank.
- **Order & Favourites Management:** Reactive Cart (BLoC) with Live Firestore synchronization, dynamic Delivery/Tax calculations, and a 30-min live countdown order tracker.
- **Device Hardware Integrations:** Google Maps for nearby vendor discovery, Geolocation (`geolocator`) for address generation, and gallery image picking (`image_picker`).
- **Complete Localization & Theming:** Full EN/AR localization with runtime switching (ARB files) and dynamic Light/Dark mode support.
- **Beta Distribution & QA:** Automated Appium test coverage (Java/TestNG) and comprehensive manual QA matrices.

---

## 🏗 Architecture & Folder Structure
```
lib/
├── core/            # Themes, Errors, Failures, UseCases
├── data/            # Models, Repositories Impl, Remote/Local Data Sources, Payment Services
├── domain/          # Entities, Repositories Interfaces
├── presentation/    # Screens (Home, Cart, Profile, etc.), Widgets, BLoCs/Cubits
├── l10n/            # app_en.arb, app_ar.arb
└── injection.dart   # GetIt Dependency Injection
```

## 🚀 Installation & Setup Instructions
1. **Prerequisites:**
   - Flutter SDK (>= 3.13.0)
   - Android Studio / VS Code
   - Java 11+ (For Appium Automation)
2. **Clone the repository:**
   ```bash
   git clone https://github.com/mahmoudkhalaf93/StreetBite.git
   cd streetbite
   ```
3. **Install Dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```
4. **Firebase Configuration:**
   - Ensure your `google-services.json` is placed in `android/app/`.
5. **Run the App:**
   ```bash
   flutter run
   ```

## 🧪 Testing (QA & Appium)
- **Manual QA:** View the Test Plans, Traceability Matrix, and Closure summaries in `docs/qa/`.
- **Automated Tests:** Java Appium tests are located in `qa_automation/src/test/java/com/streetbite/tests/`.
  - To run: Start Appium Server (`appium`), ensure emulator is running, and execute `mvn test` in the `qa_automation` folder.

## 📦 Release & Beta Distribution
- The production APK is built using `flutter build apk --release`.
- Uploaded to **Firebase App Distribution** for tester feedback. (See `docs/final_submission/firebase_app_distribution_guide.md` for details).

## 👤 Developer
**Mahmoud Khalaf**  
Flutter Engineer & Software Architect  
Capstone Graduation Project
