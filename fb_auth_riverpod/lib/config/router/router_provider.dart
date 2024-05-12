import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/pages/auth/reset_password/reset_password_page.dart';
import 'package:fb_auth_riverpod/pages/auth/signin/signin_page.dart';
import 'package:fb_auth_riverpod/pages/auth/signup/signup_page.dart';
import 'package:fb_auth_riverpod/pages/auth/verify_email/verify_email_page.dart';
import 'package:fb_auth_riverpod/pages/content/change_password/change_password_page.dart';
import 'package:fb_auth_riverpod/pages/content/home/home_page.dart';
import 'package:fb_auth_riverpod/pages/page_not_found.dart';
import 'package:fb_auth_riverpod/pages/splash/firebase_error_page.dart';
import 'package:fb_auth_riverpod/pages/splash/splash_page.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authStateStreamProvider);
  return GoRouter(
    initialLocation: Routes.splash.path,
    redirect: (context, state) {
      if (authState is AsyncLoading<User?>) {
        return Routes.splash.path;
      }

      if (authState is AsyncError<User?>) {
        return Routes.firebaseError.path;
      }

      // AsyncData를 보장한다.
      final authenticated = authState.valueOrNull != null;
      final authenticating = state.matchedLocation.contains('auth');

      if (authenticated == false) {
        return authenticating ? null : Routes.signin.path;
      }

      if (!fbAuthService.currentUser!.emailVerified) {
        return Routes.verifyEmail.path;
      }

      final verifying = state.matchedLocation == Routes.verifyEmail.path;
      final splashing = state.matchedLocation == Routes.splash.path;

      return (authenticating || verifying || splashing)
          ? Routes.home.path
          : null;
    },
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) {
          print('### Splash ###');
          return const SplashPage();
        },
      ),
      GoRoute(
        path: Routes.firebaseError.path,
        name: Routes.firebaseError.name,
        builder: (context, state) {
          return const FirebaseErrorPage();
        },
      ),
      GoRoute(
        path: Routes.signin.path,
        name: Routes.signin.name,
        builder: (context, state) {
          return const SigninPage();
        },
      ),
      GoRoute(
        path: Routes.signup.path,
        name: Routes.signup.name,
        builder: (context, state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: Routes.resetPassword.path,
        name: Routes.resetPassword.name,
        builder: (context, state) {
          return const ResetPasswordPage();
        },
      ),
      GoRoute(
        path: Routes.verifyEmail.path,
        name: Routes.verifyEmail.name,
        builder: (context, state) {
          return const VerifyEmailPage();
        },
      ),
      GoRoute(
        path: Routes.home.path,
        name: Routes.home.name,
        builder: (context, state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: Routes.changePassword.path,
            name: Routes.changePassword.name,
            builder: (context, state) {
              return const ChangePasswordPage();
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return PageNotFound(errorMessage: state.error.toString());
    },
  );
}
