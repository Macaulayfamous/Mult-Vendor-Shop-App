import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {};

  List<XFile> imagesList = [];

  getFormData({
    String? productName,
    int? price,
    String? categoryName,
    String? productDescription,
    bool? chargeShipping,
    int? shippingCharge,
    DateTime? shippingDate,
  }) {
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (price != null) {
      productData!['productPrice'] = price;
    }
    if (categoryName != null) {
      productData!['categoryName'] = categoryName;
    }
    if (productDescription != null) {
      productData!['productDescription'] = productDescription;
    }
    if (chargeShipping != null) {
      productData!['chargeShipping'] = chargeShipping;
    }
    if (shippingCharge != null) {
      productData!['shippingCharge'] = shippingCharge;
    }
    if (shippingDate != null) {
      productData!['shippingDate'] = shippingDate;
    }

    notifyListeners();
  }

  getPickedImage(image) {
    imagesList.add(image);

    notifyListeners();
  }
}
