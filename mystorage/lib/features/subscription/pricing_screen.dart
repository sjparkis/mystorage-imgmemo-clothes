import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/subscription_service.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});
  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  final _service = SubscriptionService();
  String _currentPlan = 'free';
  bool _yearly = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _service.getCurrentPlan().then((p) {
      if (mounted) setState(() => _currentPlan = p);
    });
  }

  Future<void> _purchase(String planId) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final productId = _yearly ? '${planId}_yearly' : '${planId}_monthly';
      await _service.purchase(productId);
      final updated = await _service.getCurrentPlan();
      if (mounted) setState(() => _currentPlan = updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).pricingPayFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).pricingTitle)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppLocalizations.of(context).pricingMonthly, style: const TextStyle(fontWeight: FontWeight.w600)),
                Switch(value: _yearly, onChanged: (v) => setState(() => _yearly = v)),
                Text(AppLocalizations.of(context).pricingYearly, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (_yearly)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                    child: Text(AppLocalizations.of(context).pricingDiscount, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
              ]),
              const SizedBox(height: 24),
              ...[
                _PlanData(id: 'ad_free', name: '광고제거', monthlyPrice: '1,990원', yearlyPrice: '15,900원', icon: '🚫',
                    features: ['보관함 3개', '옷 15개', 'AI 태그', '광고 없음'], highlight: false),
                _PlanData(id: 'basic', name: '기본', monthlyPrice: '3,900원', yearlyPrice: '31,900원', icon: '⭐',
                    features: ['보관함 20개', '옷 70개', 'AI 태그', '광고 없음'], highlight: true),
                _PlanData(id: 'ai_voice', name: 'AI 음성', monthlyPrice: '5,900원', yearlyPrice: '49,900원', icon: '🎤',
                    features: ['보관함 무제한', '옷 무제한', 'AI 태그', '광고 없음', 'AI 음성 검색'], highlight: false),
              ].map((plan) => _PlanCard(
                plan: plan,
                isCurrentPlan: _currentPlan == plan.id,
                yearly: _yearly,
                isLoading: _isLoading,
                onSubscribe: () => _purchase(plan.id),
              )).toList(),
            ]),
          ),
          if (_isLoading)
            const ColoredBox(
              color: Color(0x44000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _PlanData {
  final String id, name, monthlyPrice, yearlyPrice, icon;
  final List<String> features;
  final bool highlight;
  _PlanData({required this.id, required this.name, required this.monthlyPrice,
    required this.yearlyPrice, required this.icon, required this.features, required this.highlight});
}

class _PlanCard extends StatelessWidget {
  final _PlanData plan;
  final bool isCurrentPlan, yearly, isLoading;
  final VoidCallback onSubscribe;
  const _PlanCard({required this.plan, required this.isCurrentPlan, required this.yearly, required this.isLoading, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: plan.highlight ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(plan.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              Text(yearly ? '${plan.yearlyPrice}/년' : '${plan.monthlyPrice}/월',
                  style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
            ]),
          ]),
          const SizedBox(height: 12),
          ...plan.features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              const Icon(Icons.check, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(f, style: const TextStyle(fontSize: 13)),
            ]),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (isCurrentPlan || isLoading) ? null : onSubscribe,
              child: Text(isCurrentPlan ? AppLocalizations.of(context).pricingCurrentPlan : AppLocalizations.of(context).pricingStart),
            ),
          ),
        ]),
      ),
    );
  }
}
