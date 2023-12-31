import 'package:etar_q/src/features/products/products_list/product_category_list_page.dart';
import 'package:etar_q/src/routing/go_router_refresh_stream.dart';
import 'package:etar_q/src/screens/add_company.dart';
import 'package:etar_q/src/screens/custom_profile_screen.dart';
import 'package:etar_q/src/screens/custom_sign_in_screen.dart';
import 'package:etar_q/src/utils/company_list.dart';
import 'package:etar_q/src/utils/navbar_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  signIn,
  home,
  profile,
  addCompany,
  companies,
  product,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;
      if (isLoggedIn) {
        if (state.uri.path == '/sign-in') {
          return '/home';
        }
      } else {
        if (state.uri.path.startsWith('/home')) {
          return '/sign-in';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        builder: (context, state) => const CustomSignInScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const BottomNavigation(),
        routes: [
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            builder: (context, state) => const CustomProfileScreen(),
          ),
          GoRoute(
            path: 'add-company',
            name: AppRoute.addCompany.name,
            builder: (context, state) {
              final user = state.extra as User;
              return AddCompany(
                user: user,
              );
            },
          ),
          GoRoute(
            path: 'companies',
            name: AppRoute.companies.name,
            builder: (context, state) => const CompanyList(),
          ),
          GoRoute(
            path: 'product/:company',
            name: AppRoute.product.name,
            builder: (context, state) => ProductCategoryListPage(
                company: state.pathParameters["company"]!),
          ),
        ],
      ),
    ],
  );
});
