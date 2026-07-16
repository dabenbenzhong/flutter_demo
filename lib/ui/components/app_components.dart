import 'package:flutter/material.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

const double appPageMaxWidth = 393;
const double appBottomNavigationHeight = 82;
const double appFloatingActionButtonSize = 64;

class AppPageContainer extends StatelessWidget {
  const AppPageContainer({
    required this.child,
    this.maxWidth = appPageMaxWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final bottomInset =
        appBottomNavigationHeight + viewPadding.bottom + tokens.spacing.sm;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tokens.colors.background, tokens.colors.surfaceMuted],
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                tokens.spacing.sm,
                0,
                tokens.spacing.sm,
                bottomInset,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AppPageTitle extends StatelessWidget {
  const AppPageTitle({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.md,
        tokens.spacing.lg - 2,
        tokens.spacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: tokens.text.pageTitle),
          SizedBox(height: tokens.spacing.xs - 2),
          Text(
            subtitle,
            style: tokens.text.helper.copyWith(
              color: tokens.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AppContentCard extends StatelessWidget {
  const AppContentCard({
    required this.child,
    this.padding,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(tokens.radii.card),
        border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
        boxShadow: tokens.shadows.card,
      ),
      child: child,
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return AppContentCard(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        tokens.spacing.xxl - 2,
        tokens.spacing.lg,
        tokens.spacing.xxl - 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: tokens.colors.primaryAction, size: 36),
          SizedBox(height: tokens.spacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: tokens.text.sectionTitle,
          ),
          if (description != null) ...[
            SizedBox(height: tokens.spacing.xs),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: tokens.text.helper.copyWith(
                color: tokens.colors.textSecondary,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: tokens.spacing.md),
            FilledButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon ?? Icons.add_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class AppStatRow extends StatelessWidget {
  const AppStatRow({required this.label, required this.value, super.key});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: tokens.text.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Text('$value', style: tokens.text.statistic),
      ],
    );
  }
}

class AppDangerButton extends StatelessWidget {
  const AppDangerButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.colors.dangerAction,
          foregroundColor: tokens.colors.onDangerAction,
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.cancelLabel = '取消',
    super.key,
  });

  final String title;
  final Widget content;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: tokens.spacing.xl),
      backgroundColor: tokens.colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radii.dialog),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 325),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.spacing.xl - 2,
            tokens.spacing.xl - 2,
            tokens.spacing.xl - 2,
            tokens.spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tokens.text.sectionTitle.copyWith(fontSize: 21),
              ),
              SizedBox(height: tokens.spacing.sm),
              DefaultTextStyle.merge(
                style: tokens.text.body.copyWith(
                  color: tokens.colors.textSecondary,
                ),
                child: content,
              ),
              SizedBox(height: tokens.spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelLabel),
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: tokens.colors.dangerAction,
                      foregroundColor: tokens.colors.onDangerAction,
                      minimumSize: const Size(64, 42),
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.lg - 2,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required String confirmLabel,
  String cancelLabel = '取消',
}) async {
  final tokens = context.appTheme;
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: tokens.colors.textPrimary.withValues(alpha: 0.16),
    builder: (context) => AppConfirmDialog(
      title: title,
      content: content,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );

  return confirmed == true;
}

class AppBottomFormShell extends StatelessWidget {
  const AppBottomFormShell({
    required this.title,
    required this.children,
    required this.onSubmit,
    this.formKey,
    this.subtitle,
    this.submitLabel = '保存',
    this.submitIcon = Icons.check_rounded,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final GlobalKey<FormState>? formKey;
  final String submitLabel;
  final IconData submitIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final bottomSystemInset = viewInsets.bottom > 0
        ? viewInsets.bottom
        : viewPadding.bottom;
    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: tokens.text.sectionTitle.copyWith(fontSize: 22),
              ),
            ),
            IconButton(
              tooltip: '关闭',
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                fixedSize: const Size.square(36),
                backgroundColor: tokens.colors.surface.withValues(alpha: 0.72),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(tokens.radii.dialog),
                ),
              ),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: tokens.spacing.xxs),
          Text(
            subtitle!,
            style: tokens.text.helper.copyWith(
              color: tokens.colors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: tokens.spacing.md),
        ...children,
        SizedBox(height: tokens.spacing.lg),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: FilledButton.icon(
            onPressed: onSubmit,
            icon: Icon(submitIcon),
            label: Text(submitLabel),
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(
        left: tokens.spacing.lg,
        right: tokens.spacing.lg,
        top: tokens.spacing.lg - 2,
        bottom: bottomSystemInset + tokens.spacing.lg - 2,
      ),
      child: SingleChildScrollView(
        child: formKey == null
            ? formContent
            : Form(key: formKey, child: formContent),
      ),
    );
  }
}
