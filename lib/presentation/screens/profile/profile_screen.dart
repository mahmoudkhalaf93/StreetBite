import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../auth/login_screen.dart';
import '../favourites/favourites_screen.dart';
import 'widgets/contact_us_sheet.dart';
import 'widgets/help_center_sheet.dart';
import 'widgets/payment_info_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;
  bool _isFetchingLocation = false;
  bool _isBiometricEnabled = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  String? _profilePicUrl;
  String _userName = "Vlad S.";
  String _deviceInfo = "Loading device details...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDeviceInfo();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isBiometricEnabled = prefs.getBool('BIOMETRIC_ENABLED') ?? false;
      });
    }
  }

  Future<bool> _authenticateForAction(String reason) async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = canCheck || await _localAuth.isDeviceSupported();

      if (isSupported) {
        return await _localAuth.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  Future<void> _toggleBiometricLogin(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (value) {
      final authed = await _authenticateForAction('Authenticate to enable biometric login');
      if (authed) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('BIOMETRIC_ENABLED', true);
        if (user.email != null) {
          await prefs.setString('SAVED_BIOMETRIC_EMAIL', user.email!);
        }
        if (mounted) {
          setState(() => _isBiometricEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'تم تفعيل تسجيل الدخول بالبصمة بنجاح! 🔒'
                    : 'Biometric login enabled successfully! 🔒',
              ),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('BIOMETRIC_ENABLED', false);
      if (mounted) {
        setState(() => _isBiometricEnabled = false);
      }
    }
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        if (mounted) {
          setState(() {
            _deviceInfo = '${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model} (Android ${androidInfo.version.release})';
          });
        }
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        if (mounted) {
          setState(() {
            _deviceInfo = '${iosInfo.name} (${iosInfo.systemName} ${iosInfo.systemVersion})';
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _deviceInfo = 'Device Info Unavailable');
      }
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _seedDefaultAddressIfEmpty(user);

      // Listen to User document changes live from Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists && mounted) {
          final data = doc.data();
          setState(() {
            _userName = data?['name'] ?? user.displayName ?? "Vlad S.";
            _profilePicUrl = data?['profilePicUrl'] ?? user.photoURL;
          });
        }
      });
    }
  }

  Future<void> _seedDefaultAddressIfEmpty(User user) async {
    final addressesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses');

    final snapshot = await addressesRef.get();
    if (snapshot.docs.isEmpty) {
      await addressesRef.add({
        'addressEn': 'Park Way 145',
        'addressAr': 'بارك واي 145',
        'latitude': 30.0444,
        'longitude': 31.2357,
        'isDefault': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _setDefaultAddress(String selectedDocId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final addressesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses');

    final snapshot = await addressesRef.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == selectedDocId});
    }

    await batch.commit();
  }

  void _confirmSetDefaultAddress(String docId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.changeDefaultAddressTitle,
          style: const TextStyle(fontFamily: 'SF Pro', fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        content: Text(
          l10n.changeDefaultAddressConfirm,
          style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14, fontStyle: FontStyle.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.pop(ctx);
              await _setDefaultAddress(docId);
            },
            child: Text(l10n.agree, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      await storageRef.putFile(File(pickedFile.path));
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePicUrl': downloadUrl});

      if (mounted) {
        setState(() {
          _profilePicUrl = downloadUrl;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.imageUpdated),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _addNewAddress() async {
    setState(() => _isFetchingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isFetchingLocation = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Proximity duplicate check (150 meters = ~85-90% location proximity)
        final existingDocs = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .get();

        bool isDuplicate = false;
        for (var doc in existingDocs.docs) {
          final data = doc.data();
          final existingLat = (data['latitude'] as num?)?.toDouble();
          final existingLng = (data['longitude'] as num?)?.toDouble();

          if (existingLat != null && existingLng != null) {
            final distanceInMeters = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              existingLat,
              existingLng,
            );

            if (distanceInMeters < 150) {
              isDuplicate = true;
              break;
            }
          }
        }

        if (isDuplicate) {
          if (mounted) {
            setState(() => _isFetchingLocation = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'هذا العنوان مسجل بالفعل بالقرب منك!'
                      : 'This address is already registered nearby!',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }

      final geocodingAr = geo.Geocoding(locale: const Locale('ar'));
      final geocodingEn = geo.Geocoding(locale: const Locale('en'));

      List<geo.Placemark> placemarksAr = await geocodingAr.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      List<geo.Placemark> placemarksEn = await geocodingEn.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String addressEn = placemarksEn.isNotEmpty
          ? '${placemarksEn.first.street}, ${placemarksEn.first.locality}'
          : 'Current Location (${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})';
      
      String addressAr = placemarksAr.isNotEmpty
          ? '${placemarksAr.first.street}, ${placemarksAr.first.locality}'
          : addressEn;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .add({
          'addressEn': addressEn,
          'addressAr': addressAr,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'isDefault': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.locationSaved),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final user = FirebaseAuth.instance.currentUser;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // 1. Profile Photo (Centered + Tap to Upload)
                  Center(
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                              backgroundImage: _profilePicUrl != null
                                  ? NetworkImage(_profilePicUrl!)
                                  : const NetworkImage('https://i.pravatar.cc/150?img=11') as ImageProvider,
                            ),
                          ),
                          if (_isUploading)
                            Container(
                              width: 84,
                              height: 84,
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                              ),
                            )
                          else
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. User Name (Centered Below Photo)
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthSuccess) {
                        _userName = state.user.name.isNotEmpty ? state.user.name : _userName;
                      }
                      return Text(
                        _userName,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // 3. Compact & Elegant Menu Items
                  Column(
                    children: [
                      // Favourites Menu Option
                      _buildMenuItem(
                        iconData: Icons.favorite_rounded,
                        title: isArabic ? 'الوجبات المفضلة ❤️' : 'My Favourites ❤️',
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Settings (Language & Theme)
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            'assets/icons/settings.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(isDark ? Colors.white70 : const Color(0xFF333333), BlendMode.srcIn),
                          ),
                          title: Text(
                            l10n.settings,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 36, right: 8),
                              title: Text(
                                isArabic ? 'تسجيل الدخول بالبصمة' : 'Biometric Login',
                                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.normal),
                              ),
                              trailing: Switch(
                                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                                activeThumbColor: AppColors.primary,
                                value: _isBiometricEnabled,
                                onChanged: _toggleBiometricLogin,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 36, right: 8),
                              title: Text(l10n.language, style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal, color: isDark ? Colors.white70 : Colors.black87)),
                              trailing: DropdownButton<String>(
                                value: Localizations.localeOf(context).languageCode,
                                underline: const SizedBox(),
                                dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal, color: isDark ? Colors.white : Colors.black),
                                items: const [
                                  DropdownMenuItem(value: 'en', child: Text('English')),
                                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<LocaleCubit>().toggleLocale();
                                  }
                                },
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 36, right: 8),
                              title: Text(l10n.theme, style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal, color: isDark ? Colors.white70 : Colors.black87)),
                              trailing: Switch(
                                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                                activeThumbColor: AppColors.primary,
                                value: isDark,
                                onChanged: (value) {
                                  context.read<ThemeCubit>().toggleTheme();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Contact Us
                      _buildMenuItem(
                        iconPath: 'assets/icons/contact_us.svg',
                        title: l10n.contactUs,
                        isDark: isDark,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ContactUsSheet(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Help Center
                      _buildMenuItem(
                        iconPath: 'assets/icons/help_center.svg',
                        title: l10n.helpCenter,
                        isDark: isDark,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const HelpCenterSheet(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Payment Information
                      _buildMenuItem(
                        iconData: Icons.credit_card_rounded,
                        title: l10n.paymentInfo,
                        isDark: isDark,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const PaymentInfoSheet(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Addresses (Expandable with Geolocator Add Address synced with Firestore)
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: isDark ? Colors.white70 : const Color(0xFF333333),
                          ),
                          title: Text(
                            l10n.addresses,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                          children: [
                            if (user != null)
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('addresses')
                                    .orderBy('createdAt', descending: false)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                                    );
                                  }

                                  final docs = snapshot.data?.docs ?? [];
                                  return Column(
                                    children: docs.map((doc) {
                                      final data = doc.data() as Map<String, dynamic>;
                                      final title = isArabic
                                          ? (data['addressAr'] ?? data['addressEn'] ?? 'Address')
                                          : (data['addressEn'] ?? 'Address');
                                      final isDefault = data['isDefault'] == true;
                                      final lat = (data['latitude'] as num?)?.toStringAsFixed(4) ?? '';
                                      final lng = (data['longitude'] as num?)?.toStringAsFixed(4) ?? '';

                                      return ListTile(
                                        onTap: isDefault ? null : () => _confirmSetDefaultAddress(doc.id),
                                        contentPadding: const EdgeInsets.only(left: 36, right: 8),
                                        title: Text(
                                          title,
                                          style: TextStyle(
                                            fontFamily: 'SF Compact',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                          ),
                                        ),
                                        subtitle: isDefault
                                            ? Text(l10n.defaultAddress, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontStyle: FontStyle.normal))
                                            : Text('$lat, $lng', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontStyle: FontStyle.normal)),
                                        trailing: isDefault
                                            ? const Icon(Icons.check_circle, color: AppColors.primary, size: 18)
                                            : const Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 36, right: 8),
                              leading: _isFetchingLocation
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                    )
                                  : const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 18),
                              title: Text(
                                _isFetchingLocation ? l10n.fetchingLocation : l10n.addAddress,
                                style: const TextStyle(
                                  fontFamily: 'SF Compact',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  color: AppColors.primary,
                                ),
                              ),
                              onTap: _isFetchingLocation ? null : _addNewAddress,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Device Details Option (device_info_plus)
                      _buildMenuItem(
                        iconData: Icons.phone_android_rounded,
                        title: _deviceInfo,
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 4. Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout, size: 18),
                      label: Text(
                        l10n.logout,
                        style: const TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthCubit>().logOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    String? iconPath,
    IconData? iconData,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(isDark ? Colors.white70 : const Color(0xFF333333), BlendMode.srcIn),
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: 20,
                color: isDark ? Colors.white70 : const Color(0xFF333333),
              ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                color: isDark ? Colors.white : const Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
