import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _lang = ['English', 'العربية'];

class LanguageDropdown extends StatelessWidget {
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      width: 180.0,
      child: CustomDropdown(
        closedHeaderPadding: EdgeInsets.all(12.0),
        itemsListPadding: EdgeInsets.all(8.0),
        listItemPadding: EdgeInsets.all(8.0),
        decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: Colors.white),
          closedBorderRadius: BorderRadius.circular(10.0),
          closedShadow: [
            const BoxShadow(
              color: Colors.black38,
              offset: Offset(-2, 5),
              blurRadius: 10,
            )
          ],
          prefixIcon: const Icon(Icons.language),
          expandedShadow: [
            const BoxShadow(
              color: Colors.black38,
              offset: Offset(-2, 5),
              blurRadius: 10,
            )
          ],
          listItemStyle: theme.textTheme.titleSmall,
          headerStyle: theme.textTheme.titleSmall,
        ),
        initialItem: _lang[0], // بدء القائمة بالعربية
        items: _lang,
        onChanged: onChanged,
      ),
    );
  }
}