import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:veler/features/screens/profile/profile_screen.dart';
import 'package:veler/shared/models/hotel/Hotel.dart';
import 'package:veler/shared/models/reservation/Reservation.dart';
import 'package:veler/shared/services/auth/Auth.dart';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Reservation> reservations = [];
  List<Hotel> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    getReservation();
    super.initState();
  }

  void getReservation() async {
    setState(() => isLoading = true);
    await Auth.getId().then((id) async {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/user/$id"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        for (var item in body["reservations"]) {
          Reservation reservation = Reservation(
            id: item["id"],
            user_id: item["user_id"],
            hotel_id: item["hotel_id"],
            check_in: item["check_in"],
            check_out: item["check_out"],
            created_at: item["created_at"],
          );
          reservations.add(reservation);
        }

        for (var item in reservations) {
          var res = await http.get(
            Uri.parse(
              "http://10.0.2.2:3000/hotel/${item.hotel_id}",
            ),
          );
          var data = jsonDecode(res.body);

          Hotel hotel = Hotel(
            id: data["id"],
            image: data["image"],
            name: data["name"],
            description: data["description"],
            address: data["address"],
            price: data["price"] + 0.0,
            rating: data["rating"] + 0.0,
            lat: data["lat"] + 0.0,
            lng: data["lng"] + 0.0,
            created_at: data["created_at"],
          );

          hotels.add(hotel);
        }
      }
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "VELER",
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < reservations.length; i++)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 182,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(hotels[i].image!),
                                  fit: BoxFit.cover,
                                ),
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              hotels[i].name,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Color(0xffEFEFEF),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              hotels[i].address,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffC7C7C7),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    const SizedBox(width: 10),
                                    Text(
                                      reservations[i].check_in,
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Icon(Icons.arrow_forward),
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    const SizedBox(width: 10),
                                    Text(
                                      reservations[i].check_in,
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
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
