import 'package:flutter/material.dart';

push(BuildContext context, Widget view) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => view));
}

pushReplacement(BuildContext context, Widget view) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => view));
}

pushAndRemoveUntil(BuildContext context, Widget view) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => view), (route) => false);
}

pushNamed(BuildContext context, String routeName, {Object? arguments}) {
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

pushReplacementNamed(BuildContext context, String routeName,
    {Object? arguments}) {
  Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
}

pushNamedAndRemoveUntil(BuildContext context, String routeName,
    {Object? arguments}) {
  Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false,
      arguments: arguments);
}

pop(BuildContext context) {
  Navigator.of(context).pop();
}
