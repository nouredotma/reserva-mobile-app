import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservamobile/app/theme/app_colors.dart';

/// Screen layout with a header that scrolls away with the page content.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.padding = const EdgeInsets.all(16),
    this.children,
    this.body,
  }) : assert(
         title != null || titleWidget != null,
         'Provide either title or titleWidget',
       ),
       assert(
         children != null || body != null,
         'Provide either children or body',
       );

  static const double toolbarIconSize = 24;

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final EdgeInsetsGeometry padding;
  final List<Widget>? children;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = titleWidget ??
        Text(
          title!,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );

    const iconTheme = IconThemeData(
      color: AppColors.textPrimary,
      size: toolbarIconSize,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
                iconTheme: iconTheme,
                actionsIconTheme: iconTheme,
                title: resolvedTitle,
                actions: actions,
              ),
              if (children != null)
                SliverPadding(
                  padding: padding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(children!),
                  ),
                )
              else
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: body!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
