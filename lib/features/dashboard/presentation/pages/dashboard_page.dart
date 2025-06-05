import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/spending_chart.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late List<Animation<Offset>> _slideAnimations;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(
          index * 0.1,
          0.5 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(transactionsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Good ${_getGreeting()}!',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    user.when(
                                      data: (userData) => Text(
                                        userData?.firstName ?? 'User',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      loading: () => const Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      error: (_, __) => const Text(
                                        'User',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Notification Icon
                              IconButton(
                                onPressed: () {
                                  // TODO: Navigate to notifications
                                },
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              // Profile Avatar
                              GestureDetector(
                                onTap: () => context.push('/settings/profile'),
                                child: user.when(
                                  data: (userData) => CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    backgroundImage: userData?.photoUrl != null
                                        ? NetworkImage(userData!.photoUrl!)
                                        : null,
                                    child: userData?.photoUrl == null
                                        ? Text(
                                            userData?.initials ?? 'U',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  loading: () => const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white24,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  error: (_, __) => const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white24,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Dashboard Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Balance Card
                    SlideTransition(
                      position: _slideAnimations[0],
                      child: const BalanceCard(),
                    ),

                    const SizedBox(height: 16),

                    // Quick Stats
                    SlideTransition(
                      position: _slideAnimations[1],
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Today',
                              amount: '\$245.50',
                              change: '-12.5%',
                              isPositive: false,
                              icon: Icons.today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'This Week',
                              amount: '\$1,234.00',
                              change: '+8.2%',
                              isPositive: true,
                              icon: Icons.calendar_view_week,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Spending Chart
                    SlideTransition(
                      position: _slideAnimations[2],
                      child: const SpendingChart(),
                    ),

                    const SizedBox(height: 16),

                    // Quick Actions
                    SlideTransition(
                      position: _slideAnimations[3],
                      child: _buildQuickActions(),
                    ),

                    const SizedBox(height: 16),

                    // Recent Transactions
                    SlideTransition(
                      position: _slideAnimations[4],
                      child: const RecentTransactionsList(),
                    ),

                    const SizedBox(height: 100), // Bottom padding for FAB
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: 'Add Transaction',
                    color: AppTheme.primaryColor,
                    onTap: () => context.push('/add-transaction'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.analytics,
                    label: 'View Reports',
                    color: AppTheme.secondaryColor,
                    onTap: () => context.go('/reports'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Set Budget',
                    color: AppTheme.warningColor,
                    onTap: () => context.push('/settings/budget'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.file_download,
                    label: 'Export Data',
                    color: AppTheme.successColor,
                    onTap: () {
                      // TODO: Implement export functionality
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}