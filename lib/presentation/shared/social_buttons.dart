import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue,size: 30,), onPressed: () {}),
        IconButton(icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,size: 30), onPressed: () {}),
        IconButton(icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black,size: 30), onPressed: () {}),
      ],
    );
  }
}
