/*
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class UrlLauncherProvider extends ChangeNotifier{
  Future<void> callBuyer(String phoneNumber) async {
    // Launch the given URL to call phone number

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,

    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}*/
