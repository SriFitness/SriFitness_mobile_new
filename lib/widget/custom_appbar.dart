import 'package:flutter/material.dart';
import 'package:srifitness_app/widget/colo_extension.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = kToolbarHeight,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(preferredSize.height),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TColor.maincolor,
              width: 1.0,
            ),
          ),
        ),
        child: AppBar(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Image.asset(
              'images/logo_Sri.png',
              width: 300,
              height: 100,
            ),
          ),
          backgroundColor: TColor.backgroundcolor,
          elevation: 0,
        ),
      ),
    );
  }
}
