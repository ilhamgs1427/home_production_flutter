import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/Network/Models/product_model.dart';
import 'package:home_production/constans.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_production/home.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel productModel;
  ProductDetailsView(this.productModel);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  // produk controller
  final TextEditingController dateController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  // datepicker
  DateTime? _selectedDate;
  String _formattedDate = '';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      selectableDayPredicate: (DateTime day) {
        final DateTime now = DateTime.now();
        final DateTime initialDate = DateTime(now.year, now.month, now.day);
        return day.isAfter(now.subtract(Duration(days: 1))) &&
            day.isBefore(DateTime(now.year, now.month + 1)) &&
            (day.isAfter(initialDate) || day.isAtSameMomentAs(initialDate));
      },
    );
    if (picked != null && picked != _selectedDate) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      setState(() {
        _selectedDate = picked;
        _formattedDate = formatter.format(picked);
      });
    }
  }

  // sharePreferences user
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
  }

  checkout() async {
    var urlCheckout = Uri.parse(BASEURL.checkout);
    final response = await post(urlCheckout, body: {
      "id_user": userID,
      "id_product": widget.productModel.idProduct,
      "alamat": alamatController.text,
      "reservasi": _formattedDate,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                backgroundColor: whiteColor,
                title: Text(
                  "informasi",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    color: primaryButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(message,
                    style: textTextStyle.copyWith(
                      fontSize: 14,
                      color: primaryButtonColor,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      },
                      child: Text(
                        "ok",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                          color: primaryButtonColor,
                        ),
                      ))
                ],
              )));
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                backgroundColor: whiteColor,
                title: Text(
                  "informasi",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    color: primaryButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(message,
                    style: textTextStyle.copyWith(
                      fontSize: 14,
                      color: primaryButtonColor,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "kembali",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                          color: primaryButtonColor,
                        ),
                      ))
                ],
              )));
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.decimalPattern('id');
    return Scaffold(
      backgroundColor: primaryButtonColor,
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Ionicons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              child: Image.network(widget.productModel.imageProduct)),
          Container(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40, right: 14, left: 14, bottom: 40),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Layanan',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productModel.nameProduct,
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                color: primaryButtonColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Rp. " +
                                  priceFormat.format(
                                      int.parse(widget.productModel.price)),
                              style: GoogleFonts.poppins(
                                color: primaryButtonColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.productModel.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Reservasi Sekarang',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Alamat Lengkap",
                          style: textTextStyle.copyWith(
                              fontSize: 12, fontWeight: bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: greyColor.withOpacity(0.1),
                          ),
                          child: TextField(
                            enableInteractiveSelection: true,
                            controller: alamatController,
                            onSubmitted: (value) {
                              print(value);
                            },
                            style: textTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Masukkan alamat lengkap",
                                hintStyle: textTextStyle.copyWith(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.6)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 17)),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Pilih Jadwal Reservasi",
                          style: textTextStyle.copyWith(
                              fontSize: 12, fontWeight: bold),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                'Pilih tanggal',
                                style: textTextStyle.copyWith(
                                  fontSize: 12,
                                  color: whiteColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              _selectedDate != null
                                  ? _selectedDate.toString()
                                  : 'Belum memilih tanggal',
                              style: textTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryButtonColor,
                            ),
                            onPressed: () {
                              checkout();
                            },
                            child: Text(
                              "RESERVASI",
                              style: whiteTextStyle.copyWith(fontWeight: bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}