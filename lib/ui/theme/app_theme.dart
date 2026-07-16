import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const tokens = AppThemeTokens.light();
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: tokens.colors.primaryAction,
          brightness: Brightness.light,
        ).copyWith(
          primary: tokens.colors.primaryAction,
          onPrimary: tokens.colors.onPrimaryAction,
          error: tokens.colors.dangerAction,
          onError: tokens.colors.onDangerAction,
          surface: tokens.colors.surface,
          onSurface: tokens.colors.textPrimary,
          outline: tokens.colors.border,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'sans',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.colors.background,
      extensions: const [tokens],
      textTheme: TextTheme(
        displaySmall: tokens.text.pageTitle,
        titleLarge: tokens.text.sectionTitle,
        titleMedium: tokens.text.cardTitle,
        bodyMedium: tokens.text.body,
        bodySmall: tokens.text.helper,
        labelLarge: tokens.text.button,
        labelSmall: tokens.text.bottomNavigation,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.colors.primaryAction,
          foregroundColor: tokens.colors.onPrimaryAction,
          disabledBackgroundColor: tokens.colors.border,
          disabledForegroundColor: tokens.colors.textSecondary,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.lg,
            vertical: tokens.spacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radii.pill),
          ),
          textStyle: tokens.text.button,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.colors.primaryAction,
          foregroundColor: tokens.colors.onPrimaryAction,
          disabledBackgroundColor: tokens.colors.border,
          disabledForegroundColor: tokens.colors.textSecondary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.lg,
            vertical: tokens.spacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radii.pill),
          ),
          textStyle: tokens.text.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.colors.primaryAction,
          textStyle: tokens.text.button,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: tokens.colors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: tokens.colors.surface.withValues(alpha: 0.72),
        labelStyle: tokens.text.helper.copyWith(
          color: tokens.colors.textSecondary,
        ),
        floatingLabelStyle: tokens.text.helper.copyWith(
          color: tokens.colors.primaryAction,
        ),
        helperStyle: tokens.text.helper,
        errorStyle: tokens.text.helper.copyWith(
          color: tokens.colors.dangerAction,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.xs,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radii.control),
          borderSide: BorderSide(color: tokens.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radii.control),
          borderSide: BorderSide(
            color: tokens.colors.primaryAction,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radii.control),
          borderSide: BorderSide(color: tokens.colors.dangerAction),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radii.control),
          borderSide: BorderSide(color: tokens.colors.dangerAction, width: 1.4),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.colors.surface,
        modalBackgroundColor: tokens.colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radii.sheet),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.colors.surface.withValues(alpha: 0.94),
        elevation: 0,
        indicatorColor: tokens.colors.primaryAction.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected
                ? tokens.colors.primaryAction
                : tokens.colors.textSecondary,
            size: 26,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return tokens.text.bottomNavigation.copyWith(
            color: isSelected
                ? tokens.colors.primaryAction
                : tokens.colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.colors.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: tokens.text.sectionTitle,
        contentTextStyle: tokens.text.body.copyWith(
          color: tokens.colors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radii.dialog),
        ),
      ),
    );
  }
}

extension AppThemeLookup on BuildContext {
  AppThemeTokens get appTheme =>
      Theme.of(this).extension<AppThemeTokens>() ??
      const AppThemeTokens.light();
}

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.colors,
    required this.text,
    required this.spacing,
    required this.radii,
    required this.shadows,
  });

  const AppThemeTokens.light()
    : colors = const AppColorTokens(
        background: Color(0xfffff2e4),
        surface: Color(0xfffff8f1),
        surfaceMuted: Color(0xfff2e3d8),
        textPrimary: Color(0xff2e1608),
        textSecondary: Color(0xb82e1608),
        border: Color(0x38c9823a),
        primaryAction: Color(0xffc9823a),
        onPrimaryAction: Color(0xffffffff),
        dangerAction: Color(0xffb94731),
        onDangerAction: Color(0xffffffff),
        eventMarker: Color(0xff2d7bf0),
        statusSuccess: Color(0xff2f9f66),
        statusWarning: Color(0xffd58915),
        statusInfo: Color(0xff4d71cf),
        statusCompleted: Color(0xff80746a),
      ),
      text = const AppTextTokens(
        pageTitle: TextStyle(
          color: Color(0xff2e1608),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        sectionTitle: TextStyle(
          color: Color(0xff2e1608),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        cardTitle: TextStyle(
          color: Color(0xff2e1608),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        body: TextStyle(
          color: Color(0xff2e1608),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
          letterSpacing: 0,
        ),
        helper: TextStyle(
          color: Color(0xb82e1608),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: 0,
        ),
        statistic: TextStyle(
          color: Color(0xffc9823a),
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        button: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        bottomNavigation: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      spacing = const AppSpacingTokens(
        xxs: 4,
        xs: 8,
        sm: 12,
        md: 16,
        lg: 20,
        xl: 24,
        xxl: 32,
      ),
      radii = const AppRadiusTokens(
        xs: 4,
        sm: 8,
        control: 14,
        card: 28,
        dialog: 18,
        sheet: 28,
        pill: 999,
      ),
      shadows = const AppShadowTokens(
        card: [
          BoxShadow(
            color: Color(0x1f4c2d18),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
          BoxShadow(
            color: Color(0x80ffffff),
            blurRadius: 12,
            offset: Offset(-6, -6),
          ),
        ],
        navigation: [
          BoxShadow(
            color: Color(0x144c2d18),
            blurRadius: 22,
            offset: Offset(0, -8),
          ),
        ],
        floating: [
          BoxShadow(
            color: Color(0x6bc9823a),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      );

  final AppColorTokens colors;
  final AppTextTokens text;
  final AppSpacingTokens spacing;
  final AppRadiusTokens radii;
  final AppShadowTokens shadows;

  @override
  AppThemeTokens copyWith({
    AppColorTokens? colors,
    AppTextTokens? text,
    AppSpacingTokens? spacing,
    AppRadiusTokens? radii,
    AppShadowTokens? shadows,
  }) {
    return AppThemeTokens(
      colors: colors ?? this.colors,
      text: text ?? this.text,
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      shadows: shadows ?? this.shadows,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) {
      return this;
    }

    return AppThemeTokens(
      colors: AppColorTokens.lerp(colors, other.colors, t),
      text: AppTextTokens.lerp(text, other.text, t),
      spacing: AppSpacingTokens.lerp(spacing, other.spacing, t),
      radii: AppRadiusTokens.lerp(radii, other.radii, t),
      shadows: AppShadowTokens.lerp(shadows, other.shadows, t),
    );
  }
}

@immutable
class AppColorTokens {
  const AppColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.primaryAction,
    required this.onPrimaryAction,
    required this.dangerAction,
    required this.onDangerAction,
    required this.eventMarker,
    required this.statusSuccess,
    required this.statusWarning,
    required this.statusInfo,
    required this.statusCompleted,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color primaryAction;
  final Color onPrimaryAction;
  final Color dangerAction;
  final Color onDangerAction;
  final Color eventMarker;
  final Color statusSuccess;
  final Color statusWarning;
  final Color statusInfo;
  final Color statusCompleted;

  static AppColorTokens lerp(AppColorTokens a, AppColorTokens b, double t) {
    return AppColorTokens(
      background: Color.lerp(a.background, b.background, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      surfaceMuted: Color.lerp(a.surfaceMuted, b.surfaceMuted, t)!,
      textPrimary: Color.lerp(a.textPrimary, b.textPrimary, t)!,
      textSecondary: Color.lerp(a.textSecondary, b.textSecondary, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      primaryAction: Color.lerp(a.primaryAction, b.primaryAction, t)!,
      onPrimaryAction: Color.lerp(a.onPrimaryAction, b.onPrimaryAction, t)!,
      dangerAction: Color.lerp(a.dangerAction, b.dangerAction, t)!,
      onDangerAction: Color.lerp(a.onDangerAction, b.onDangerAction, t)!,
      eventMarker: Color.lerp(a.eventMarker, b.eventMarker, t)!,
      statusSuccess: Color.lerp(a.statusSuccess, b.statusSuccess, t)!,
      statusWarning: Color.lerp(a.statusWarning, b.statusWarning, t)!,
      statusInfo: Color.lerp(a.statusInfo, b.statusInfo, t)!,
      statusCompleted: Color.lerp(a.statusCompleted, b.statusCompleted, t)!,
    );
  }
}

@immutable
class AppTextTokens {
  const AppTextTokens({
    required this.pageTitle,
    required this.sectionTitle,
    required this.cardTitle,
    required this.body,
    required this.helper,
    required this.statistic,
    required this.button,
    required this.bottomNavigation,
  });

  final TextStyle pageTitle;
  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle body;
  final TextStyle helper;
  final TextStyle statistic;
  final TextStyle button;
  final TextStyle bottomNavigation;

  static AppTextTokens lerp(AppTextTokens a, AppTextTokens b, double t) {
    return AppTextTokens(
      pageTitle: TextStyle.lerp(a.pageTitle, b.pageTitle, t)!,
      sectionTitle: TextStyle.lerp(a.sectionTitle, b.sectionTitle, t)!,
      cardTitle: TextStyle.lerp(a.cardTitle, b.cardTitle, t)!,
      body: TextStyle.lerp(a.body, b.body, t)!,
      helper: TextStyle.lerp(a.helper, b.helper, t)!,
      statistic: TextStyle.lerp(a.statistic, b.statistic, t)!,
      button: TextStyle.lerp(a.button, b.button, t)!,
      bottomNavigation: TextStyle.lerp(
        a.bottomNavigation,
        b.bottomNavigation,
        t,
      )!,
    );
  }
}

@immutable
class AppSpacingTokens {
  const AppSpacingTokens({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static AppSpacingTokens lerp(
    AppSpacingTokens a,
    AppSpacingTokens b,
    double t,
  ) {
    return AppSpacingTokens(
      xxs: lerpDouble(a.xxs, b.xxs, t)!,
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
      xxl: lerpDouble(a.xxl, b.xxl, t)!,
    );
  }
}

@immutable
class AppRadiusTokens {
  const AppRadiusTokens({
    required this.xs,
    required this.sm,
    required this.control,
    required this.card,
    required this.dialog,
    required this.sheet,
    required this.pill,
  });

  final double xs;
  final double sm;
  final double control;
  final double card;
  final double dialog;
  final double sheet;
  final double pill;

  static AppRadiusTokens lerp(AppRadiusTokens a, AppRadiusTokens b, double t) {
    return AppRadiusTokens(
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      control: lerpDouble(a.control, b.control, t)!,
      card: lerpDouble(a.card, b.card, t)!,
      dialog: lerpDouble(a.dialog, b.dialog, t)!,
      sheet: lerpDouble(a.sheet, b.sheet, t)!,
      pill: lerpDouble(a.pill, b.pill, t)!,
    );
  }
}

@immutable
class AppShadowTokens {
  const AppShadowTokens({
    required this.card,
    required this.navigation,
    required this.floating,
  });

  final List<BoxShadow> card;
  final List<BoxShadow> navigation;
  final List<BoxShadow> floating;

  static AppShadowTokens lerp(AppShadowTokens a, AppShadowTokens b, double t) {
    return AppShadowTokens(
      card: BoxShadow.lerpList(a.card, b.card, t) ?? b.card,
      navigation:
          BoxShadow.lerpList(a.navigation, b.navigation, t) ?? b.navigation,
      floating: BoxShadow.lerpList(a.floating, b.floating, t) ?? b.floating,
    );
  }
}
