class Reservation {
  late String id;
  late String user_id;
  late String hotel_id;
  late String check_in;
  late String check_out;
  late String created_at;

  Reservation({
    required this.id,
    required this.user_id,
    required this.hotel_id,
    required this.check_in,
    required this.check_out,
    required this.created_at,
  });
}
