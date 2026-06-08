import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/deploy_flow_logo_title.dart';

class DeployFlowSliverPage extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? header;
  final Widget? stickyHeader;
  final double stickyHeaderHeight;
  final List<Widget> slivers;

  const DeployFlowSliverPage({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.header,
    this.stickyHeader,
    this.stickyHeaderHeight = 124,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const DeployFlowLogoTitle(),
            leading: leading,
            actions: actions,
          ),

          if (header != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: header!,
              ),
            ),

          if (stickyHeader != null)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                height: stickyHeaderHeight,
                child: stickyHeader!,
              ),
            ),

          ...slivers,
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _StickyHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
