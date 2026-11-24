import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/storage/storage_detail_screen.dart';
import '../features/storage/add_storage_screen.dart';
import '../features/cloth/add_cloth_screen.dart';
import '../features/cloth/cloth_detail_screen.dart';
import '../features/qr/qr_scan_screen.dart';
import '../features/qr/qr_sticker_screen.dart';
import '../features/search/search_screen.dart';
import '../features/subscription/pricing_screen.dart';
import '../features/admin/admin_dashboard.dart';
import '../data/models/storage_location.dart';

final appRouter = GoRouter(
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuth = session != null;
    final loc = state.matchedLocation;
    final isPublic = loc == '/login' || loc == '/signup';
    if (!isAuth && !isPublic) return '/login';
    if (isAuth && isPublic) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/storage/add', builder: (_, __) => const AddStorageScreen()),
    GoRoute(
      path: '/storage/edit/:id',
      builder: (_, state) =>
          AddStorageScreen(existing: state.extra as StorageLocation),
    ),
    GoRoute(
      path: '/storage/:id',
      builder: (_, state) =>
          StorageDetailScreen(storageId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/cloth/add/:storageId',
      builder: (_, state) =>
          AddClothScreen(storageId: state.pathParameters['storageId']!),
    ),
    GoRoute(
      path: '/cloth/:id',
      builder: (_, state) =>
          ClothDetailScreen(clothId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(path: '/qr-scan', builder: (_, __) => const QrScanScreen()),
    GoRoute(
      path: '/qr-sticker',
      builder: (_, state) =>
          QrStickerScreen(storage: state.extra as StorageLocation),
    ),
    GoRoute(
      path: '/pricing',
      builder: (_, __) => const PricingScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (_, __) => const AdminDashboard(),
    ),
  ],
);
