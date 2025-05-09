import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Color? txtColor;
  final Color? iconColor;
  final Color? bgColor;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.txtColor,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: SvgPicture.asset(
          icon
        ),
        title: Text(title, style: TextStyle(color: txtColor)),
        tileColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}