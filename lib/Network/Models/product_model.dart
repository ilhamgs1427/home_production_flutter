class ProductModel {
  final String idProduct;
  final String idCategory;
  final String nameProduct;
  final String description;
  final String imageProduct;
  final String price;
  final String createdAt;

  ProductModel({
    required this.idProduct,
    required this.idCategory,
    required this.nameProduct,
    required this.description,
    required this.imageProduct,
    required this.price,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      idProduct: data['id'],
      idCategory: data['jenis'],
      nameProduct: data['name'],
      description: data['deskripsi'],
      imageProduct: data['image'],
      price: data['harga'],
      createdAt: data['created_at'],
    );
  }
}
