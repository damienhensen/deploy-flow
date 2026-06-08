import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class DeployFlowLogoTitle extends StatelessWidget {
  const DeployFlowLogoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/logo.svg', width: 32, height: 32),
        const SizedBox(width: AppSpacing.sm),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Deploy',
                style: textStyle?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Flow',
                style: textStyle?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
