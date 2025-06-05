import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QuickStatsCard extends StatefulWidget {
  final String title;
  final String amount;
  final String change;
  final bool isPositive;
  final IconData icon;
  final VoidCallback? onTap;

  const QuickStatsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.change,
    required this.isPositive,
    required this.icon,
    this.onTap,
  });

  @override
  State<QuickStatsCard> createState() => _QuickStatsCardState();
}

class _QuickStatsCardState extends State<QuickStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.isPositive
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isPositive
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: widget.isPositive
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.change,
                            style: TextStyle(
                              color: widget.isPositive
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                // Amount
                Text(
                  widget.amount,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedStatsCard extends StatefulWidget {
  final String title;
  final double amount;
  final double previousAmount;
  final IconData icon;
  final Color color;
  final String currency;

  const AnimatedStatsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.previousAmount,
    required this.icon,
    required this.color,
    this.currency = '\$',
  });

  @override
  State<AnimatedStatsCard> createState() => _AnimatedStatsCardState();
}

class _AnimatedStatsCardState extends State<AnimatedStatsCard>
    with TickerProviderStateMixin {
  late AnimationController _countController;
  late AnimationController _slideController;
  late Animation<double> _countAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _countController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _countAnimation = Tween<double>(
      begin: 0.0,
      end: widget.amount,
    ).animate(CurvedAnimation(
      parent: _countController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
    _countController.forward();
  }

  @override
  void didUpdateWidget(AnimatedStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _countAnimation = Tween<double>(
        begin: oldWidget.amount,
        end: widget.amount,
      ).animate(CurvedAnimation(
        parent: _countController,
        curve: Curves.easeOutCubic,
      ));
      _countController.reset();
      _countController.forward();
    }
  }

  @override
  void dispose() {
    _countController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changePercent = widget.previousAmount != 0
        ? ((widget.amount - widget.previousAmount) / widget.previousAmount) * 100
        : 0.0;
    final isPositive = changePercent >= 0;

    return SlideTransition(
      position: _slideAnimation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.1),
                widget.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 24,
                    ),
                  ),
                  if (widget.previousAmount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isPositive
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${changePercent.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: isPositive
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Animated Amount
              AnimatedBuilder(
                animation: _countAnimation,
                builder: (context, child) {
                  return Text(
                    '${widget.currency}${_countAnimation.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}