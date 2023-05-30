import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Pages/detailproduk.dart';
import 'package:home_production/constans.dart';
import 'package:http/http.dart' as http;
import 'package:home_production/Network/Models/product_model.dart';
import 'package:intl/intl.dart';
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class beranda extends StatefulWidget {
  const beranda({super.key});

  @override
  State<beranda> createState() => _beranda();
}

//get product from api
class _beranda extends State<beranda> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> listProduct = [];
  getProduct() async {
    var urlProduct = Uri.parse(BASEURL.getProduct);
    final response = await http.get(urlProduct);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> product in data) {
          listProduct.add(ProductModel.fromJson(product));
        }
      });
    }
  }

  // get id user
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
  }

  // searchProduct(String text) {
  //   if (text.isEmpty) {
  //     setState(() {});
  //   } else {
  //     listProduct.forEach((element) {
  //       if (element.nameProduct.toLowerCase().contains(text)) {
  //         listProduct.add(element);
  //       }
  //     });
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: ListView(
        children: [
          Container(
            height: 210,
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: primaryButtonColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 30,
                      color: whiteColor,
                    ),
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    )
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "Home Production",
                    style: whiteTextStyle.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    // onChanged: searchProduct,
                    // controller: searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here.....",
                        hintStyle: textTextStyle,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Layanan Kami",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryButtonColor,
                  ),
                ),
                Text(
                  "All",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryButtonColor,
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: listProduct.length,
              itemBuilder: (context, i) {
                final y = listProduct[i];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsView(y)));
                  },
                  child: Menuproduk(
                    nameProduct: y.nameProduct,
                    imageProduct: y.imageProduct,
                    priceProduct: y.price,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class Menuproduk extends StatelessWidget {
  final String imageProduct;
  final String nameProduct;
  final String priceProduct;

  Menuproduk({
    required this.imageProduct,
    required this.nameProduct,
    required this.priceProduct,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.decimalPattern('id');
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
                  borderRadius: BorderRadius.circular(20.0),
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
              top: 27,
              left: 30,
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 130,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/' + imageProduct),
                    ),
                  ),
                ),
              )),
          Positioned(
              top: 45,
              left: 165,
              child: Container(
                height: 150,
                width: 165,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameProduct,
                        style: textTextStyle.copyWith(
                          fontSize: 20,
                          color: primaryButtonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rp. " + priceFormat.format(int.parse(priceProduct)),
                        style: textTextStyle.copyWith(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: primaryButtonColor,
                        height: 10,
                        thickness: 1,
                      ),
                      Text(
                        "Exstra Bonus",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    ]),
              ))
        ],
      ),
    );
  }
}
