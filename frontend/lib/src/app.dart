import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/views/login_view.dart';
import 'features/auth/views/otp_verification_view.dart';
import 'features/navigation/main_navigation_view.dart';
import 'features/profile/views/profile_setup_view.dart';
import 'features/loan/views/loan_application_view.dart';
import 'features/settings/settings_view.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/settings_service.dart';
import 'core/theme/app_theme.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = SettingsController(SettingsService());
    _settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case LoginView.routeName:
                    return const LoginView();
                  case OtpVerificationView.routeName:
                    return const OtpVerificationView();
                  case ProfileSetupView.routeName:
                    final args =
                        routeSettings.arguments as Map<String, dynamic>?;
                    final userId = args?['userId'] as String? ?? '';
                    return ProfileSetupView(userId: userId);
                  case MainNavigationView.routeName:
                    return const MainNavigationView();
                  case LoanApplicationView.routeName:
                    return const LoanApplicationView();
                  case SettingsView.routeName:
                    return SettingsView(controller: _settingsController);
                  default:
                    return const LoginView();
                }
              },
            );
          },
        );
      },
    );
  }
}
