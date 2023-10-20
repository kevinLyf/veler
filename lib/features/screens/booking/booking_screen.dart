import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veler/features/screens/menu/menu_screen.dart';
import 'package:veler/shared/services/auth/Auth.dart';

class BookingScreen extends StatefulWidget {
  late String hotel_id;

  BookingScreen({
    super.key,
    required this.hotel_id,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _checkIn = TextEditingController();
  final _checkOut = TextEditingController();
  bool isLoading = false;
  late Map<String, dynamic> user;

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
  void initState() {
    getData();
    super.initState();
  }

  void pickData(bool isCheckin) async {
    DateTime currentDate = DateTime.now();
    DateTime lastDateOfCurrentYear = DateTime(currentDate.year, 12, 31);

    var picker = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: lastDateOfCurrentYear,
    );

    if (picker != null) {
      debugPrint(picker.toString());
      var date = picker.toString().split(" ")[0];

      setState(() {
        isCheckin ? _checkIn.text = date : _checkOut.text = date;
      });
    }
  }

  Future<void> handleMakeReservation() async {
    if (_checkIn.text.isEmpty || _checkOut.text.isEmpty) return;

    Map<String, dynamic> data = {
      "hotel": {
        "connect": {
          "id": widget.hotel_id,
        }
      },
      "user": {
        "connect": {
          "id": user["id"],
        }
      },
      "check_in": _checkIn.text,
      "check_out": _checkOut.text
    };

    try {
      var response = await http.post(
        Uri.parse(
          "http://10.0.2.2:3000/reservation",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackBar(
          "Reservation sucessfully created",
          Icons.done_rounded,
          Colors.green,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      } else {
        showSnackBar(
          "Something wrong happened",
          Icons.close_rounded,
          Theme.of(context).colorScheme.primary,
        );
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void showSnackBar(String title, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              handleMakeReservation();
            }
          },
          child: Center(
            child: Text(
              "Make the reservation",
              style: const TextStyle(
                fontFamily: "Nunito",
                color: Color(0xffEFEFEF),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter some information",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xffEFEFEF),
                ),
              ),
              const Text(
                "We will use it to make a reservation",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xffC7C7C7),
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      leading: Icon(
                        Icons.date_range_rounded,
                        size: 26,
                        color: Color(0xffC7C7C7),
                      ),
                      title: Text(
                        "Check-in",
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffC7C7C7)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => pickData(true),
                      child: TextFormField(
                        enabled: false,
                        controller: _checkIn,
                        decoration: InputDecoration(
                          hintText: _checkIn.text,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffC7C7C7),
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) return "Select a valid day";

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      leading: Icon(
                        Icons.date_range_rounded,
                        size: 26,
                        color: Color(0xffC7C7C7),
                      ),
                      title: Text(
                        "Check-out",
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffC7C7C7)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => pickData(false),
                      child: TextFormField(
                        controller: _checkOut,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: _checkOut.text,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffC7C7C7),
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) return "Select a valid day";

                          return null;
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
