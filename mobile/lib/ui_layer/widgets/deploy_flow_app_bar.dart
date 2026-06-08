import 'package:flutter/material.dart';

class DeployFlowAppBar extends StatelessWidget {
  const DeployFlowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(pinned: true, title: const Text('DeployFlow'));
  }
}
