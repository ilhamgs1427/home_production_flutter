class BASEURL {
  static String ipAddress = "192.168.0.117";
  static String apiRegister =
      "http://$ipAddress/home_productionDB/register_api.php";
  static String apiLogin = "http://$ipAddress/home_productionDB/login_api.php";
  static String getProduct =
      "http://$ipAddress/home_productionDB/get_product.php";
  static String checkout = "http://$ipAddress/home_productionDB/checkout.php";
  static String history =
      "http://$ipAddress/home_productionDB/get_history.php?id_user=";
  static String transfer =
      "http://$ipAddress/home_productionDB/bukti_transfer.php";
  static String deleteRiwayat =
      "http://$ipAddress/home_productionDB/delete_riwayat.php";
}
