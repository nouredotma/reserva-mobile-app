import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservamobile/app/theme/app_colors.dart';

/// [AppBar] that is white at scroll offset zero and [AppColors.navBar] once scrolled.
class ScrollAwareScaffold extends StatefulWidget {
  const ScrollAwareScaffold({
    super.key,
    this.title,
    this.titleBuilder,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    required this.body,
  }) : assert(
         title != null || titleBuilder != null,
         'Provide either title or titleBuilder',
       );

  static const double toolbarIconSize = 24;

  final String? title;
  final Widget Function(bool isScrolled)? titleBuilder;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget body;

  @override
  State<ScrollAwareScaffold> createState() => _ScrollAwareScaffoldState();
}

class _ScrollAwareScaffoldState extends State<ScrollAwareScaffold> {
  bool _isScrolled = false;

  bool _onScroll(ScrollNotification notification) {
    final scrolled = notification.metrics.pixels > 0;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isScrolled ? AppColors.navBar : AppColors.background;
    final foregroundColor =
        _isScrolled ? AppColors.textOnDark : AppColors.textPrimary;

    final iconTheme = IconThemeData(
      color: foregroundColor,
      size: ScrollAwareScaffold.toolbarIconSize,
    );

    final title = widget.titleBuilder != null
        ? widget.titleBuilder!(_isScrolled)
        : Text(
            widget.title!,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _isScrolled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            iconTheme: iconTheme,
            actionsIconTheme: iconTheme,
            title: title,
            actions: widget.actions,
          ),
          body: widget.body,
        ),
      ),
    );
  }
}
