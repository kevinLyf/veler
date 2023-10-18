import 'package:flutter/material.dart';
import 'package:veler/shared/services/auth/Auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> user;
  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() => isLoading = true);

    final id = await Auth.getId().then((data) => data);
    final name = await Auth.getName().then((data) => data);
    final email = await Auth.getEmail().then((data) => data);
    final password = await Auth.getPassword().then((data) => data);
    final admin = await Auth.getAdmin().then((data) => data);

    Map<String, dynamic> data = {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "admin": admin
    };

    setState(() {
      user = data;
      isLoading = false;
    });
    debugPrint(user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Text(
                user.toString(),
              ),
            ),
    );
  }
}
