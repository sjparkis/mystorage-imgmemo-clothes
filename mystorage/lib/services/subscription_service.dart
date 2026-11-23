import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';

class SubscriptionService {
  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration('YOUR_REVENUECAT_API_KEY')
      ..appUserID = Supabase.instance.client.auth.currentUser?.id);
  }

  Future<String> getCurrentPlan() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return 'free';
    final row = await Supabase.instance.client
        .from('subscriptions')
        .select('plan')
        .eq('user_id', userId)
        .maybeSingle();
    return row?['plan'] as String? ?? 'free';
  }

  Future<bool> canAddStorage(int currentCount) async {
    final plan = await getCurrentPlan();
    final limit = AppConstants.planLimits[plan]?['storages'] ?? 0;
    return limit == -1 || currentCount < limit;
  }

  Future<bool> canAddCloth(int currentCount) async {
    final plan = await getCurrentPlan();
    final limit = AppConstants.planLimits[plan]?['clothes'] ?? 0;
    return limit == -1 || currentCount < limit;
  }

  Future<bool> hasVoiceSearch() async {
    final plan = await getCurrentPlan();
    return plan == 'ai_voice';
  }

  Future<void> purchase(String productId) async {
    final offerings = await Purchases.getOfferings();
    final packages = offerings.current?.availablePackages ?? [];
    final package = packages.cast<Package?>().firstWhere(
      (p) => p?.storeProduct.identifier == productId,
      orElse: () => null,
    );
    if (package == null) throw Exception('상품을 찾을 수 없습니다: $productId');
    await Purchases.purchasePackage(package);
  }
}
