import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Network/Models/history_model.dart';

import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/constans.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

class riwayatPage extends StatefulWidget {
  riwayatPage({super.key});

  @override
  State<riwayatPage> createState() => _riwayatPageState();
}

class _riwayatPageState extends State<riwayatPage> {
  // get id user
  List<HistoryOrderModel> list = [];
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
    getHistory();
  }

  getHistory() async {
    var urlHistory = Uri.parse(BASEURL.history + userID!);
    final response = await get(urlHistory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          for (Map<String, dynamic> item in data) {
            list.add(HistoryOrderModel.fromJson(item));
          }
          print(list[0].idUser);
        } else {
          // Respons JSON kosong, lakukan tindakan yang sesuai
          print("user kosong");
        }
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        centerTitle: true,
        title: Text(
          "Riwayat resevervasi",
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list.reversed.toList()[i];
            return InkWell(
              child: cartRiwayat(
                NamaLengkapPesanan: x.namaUser,
                phonePesanan: x.notelepon,
                AlamatPesanan: x.alamat,
                TanggalPesanan: x.reservasi,
                namaproductPesanan: x.namaProduct,
                IdPesanan: x.idOrders,
              ),
            );
          }),
    );
  }
}

class cartRiwayat extends StatelessWidget {
  final String NamaLengkapPesanan;
  final String AlamatPesanan;
  final String phonePesanan;
  final String TanggalPesanan;
  final String namaproductPesanan;
  final String IdPesanan;

  cartRiwayat({
    required this.NamaLengkapPesanan,
    required this.AlamatPesanan,
    required this.phonePesanan,
    required this.TanggalPesanan,
    required this.namaproductPesanan,
    required this.IdPesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 23,
            child: Material(
              child: Container(
                height: 150.0,
                width: 320.0,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 40,
            child: Container(
              height: 150,
              width: 190,
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "No Telepon",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Alamat",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Reservasi",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Layanan",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Id Pesanan",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                      ]),
                  SizedBox(width: 5),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                      ]),
                  SizedBox(width: 5),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NamaLengkapPesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          phonePesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          AlamatPesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          TanggalPesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          namaproductPesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          IdPesanan,
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 275,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: primaryButtonColor,
              ),
              child: Text(
                "pdf",
                style: whiteTextStyle.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
