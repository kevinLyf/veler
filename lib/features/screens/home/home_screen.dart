import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:veler/features/screens/details/details_screen.dart';
import 'package:veler/features/screens/profile/profile_screen.dart';
import 'package:veler/shared/models/hotel/Hotel.dart';
import 'package:veler/shared/services/auth/Auth.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> user;
  bool isLoading = true;
  List<Hotel> hotels = [];

  @override
  void initState() {
    getData();
    getHotels();
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

  Future<void> getHotels() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:3000/hotel"));
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var item in body) {
          var hotel = Hotel(
            id: item["id"],
            image: item["image"],
            name: item["name"],
            description: item["description"],
            address: item["address"],
            price: item["price"] + 0.0,
            rating: item["rating"] + 0.0,
            lat: item["lat"] + 0.0,
            lng: item["lng"] + 0.0,
            created_at: item["created_at"],
          );

          hotels.add(hotel);
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      setState(() => isLoading = false);
      debugPrint(hotels.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                    id: user["id"],
                    name: user["name"],
                    email: user["email"],
                    admin: user["admin"]),
              ),
            ),
            icon: Icon(
              Icons.person_rounded,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: getHotels,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item in hotels)
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                id: item.id,
                                image: item.image!,
                                name: item.name,
                                description: item.description!,
                                address: item.address,
                                price: item.price,
                                rating: item.rating,
                                lat: item.lat,
                                lng: item.lng,
                                created_at: item.created_at,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 182,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(item.image!),
                                      fit: BoxFit.cover,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 10,
                                        bottom: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 22,
                                                color: Colors.orange,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item.rating.toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.address,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC7C7C7),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.name,
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
                                  "\$${item.price}",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xffC7C7C7)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.description ?? "Not informed",
                                  maxLines: 4,
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC7C7C7),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
