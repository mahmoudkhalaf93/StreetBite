# 🍔 StreetBite V1.0 — Flutter Food Discovery & Ordering App

**StreetBite V1.0** is a full-featured, bilingual (English & Arabic) food discovery and ordering application developed as a graduation capstone project. Built using **Flutter** and strict **Clean Architecture** principles, the app integrates live REST APIs, Firebase services, and native device capabilities to deliver a smooth and scalable user experience.

---

### ✨ Key Highlights & Features
- **Clean Architecture & Design Patterns:** Layered structure (Data, Domain, Presentation) utilizing BLoC/Cubit, GetIt DI, Builder (User model), Factory (MealRepository), and Singleton (Firestore service).
- **Authentication & Persistence:** Secure Email/Password authentication with persistent sessions via Firebase Authentication.
- **Live Menu & Caching:** Real-time meal fetching from TheMealDB API via Dio, combined with offline caching using `shared_preferences`.
- **Order & Favourites Management:** Reactive Cart (BLoC), order placement, and live synchronisation of user favourites with Cloud Firestore.
- **Device Hardware Integrations:** Google Maps for nearby vendor discovery, Biometric authentication (`local_auth`) for profile security, and gallery image picking (`image_picker`).
- **Complete Localization & Theming:** Full EN/AR localization with runtime switching (ARB files) and dynamic Light/Dark mode support.
- **Beta Distribution & QA:** Release APK delivered via Firebase App Distribution with manual test suites (Jira) and automated Appium test coverage.
