import 'package:flutter/material.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/utils/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final bool showBackArrow;
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.showBackArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color1,
      elevation: 0,
      title: title != null
          ? Text(
              title!,
              style: getTitleStyle(fontSize: 20, color: Colors.white),
            )
          : null,
      centerTitle: centerTitle ?? true,
      leading: _buildLeading(context),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackArrow && Navigator.canPop(context)) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
