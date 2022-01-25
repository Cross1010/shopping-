import 'dart:convert';

import 'package:shop_app/models/address.dart';
import 'package:shop_app/models/user.dart';

import 'product.dart';

class Order {
  String? id;
  String idClient;
  String idAddress;
  double lat;
  double lng;
  String status;
  int? timestamp;
  List<Product>? products = [];
  List<Order>? orders = [];
  List<dynamic> toList = [];
  User? client;
  Address? address;

  Order({
    this.id,
    required this.idClient,
    required this.idAddress,
    required this.lat,
    required this.lng,
    required this.status,
    this.timestamp,
    this.products,
    this.orders,
    this.client,
    this.address,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"] ?? 'null',
        idClient: json["id_client"],
        idAddress: json["id_address"],
        lat: json["lat"] != null ? json["lat"].toDouble() : 0,
        lng: json["lng"] != null ? json["lng"].toDouble() : 0,
        status: json["status"],
        timestamp: int.parse(json["timestamp"]),
        products: json['products'] != null
            ? List<Product>.from(
                json['products'].map((e) => Product.fromMap(e)) ?? [],
              )
            : null,
        client: json["client"] != null ? User.fromMap(json["client"]) : null,
        address:
            json['address'] != null ? Address.fromMap(json['address']) : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_client": idClient,
        "id_address": idAddress,
        "lat": lat,
        "lng": lng,
        "status": status,
        "timestamp": timestamp,
        "products": products ?? [],
        "client": client ?? [],
        "address": address ?? [],
      };
}
