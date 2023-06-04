class BASEURL {
  static String ipAddress = "192.168.1.10";
  static String apiRegister = "http://$ipAddress/streaming_DB/register_api.php";
  static String apiLogin = "http://$ipAddress/streaming_DB/login_api.php";
  static String getProduct = "http://$ipAddress/streaming_DB/get_product.php";
  static String checkout = "http://$ipAddress/streaming_DB/checkout.php";
  static String history =
      "http://$ipAddress/streaming_DB/get_history.php?id_user=";
  static String transfer = "http://$ipAddress/streaming_DB/bukti_transfer.php";
  static String deleteRiwayat =
      "http://$ipAddress/streaming_DB/delete_riwayat.php";
}
