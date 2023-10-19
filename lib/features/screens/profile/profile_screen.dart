import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  late String id;
  late String name;
  late String email;
  late bool admin;

  ProfileScreen({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.admin,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        title: Text(
          "Profile",
          maxLines: 1,
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
