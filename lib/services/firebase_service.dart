import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final FirebaseStorage _storage = FirebaseStorage.instance;

class FirebaseService {
  CollectionReference homeBanner = _firestore.collection('homeBanners');

  CollectionReference categories = _firestore.collection('categories');

  // Future<List> uploadImages(
  //     List<XFile>? images, String ref, ProductProvider productProvider) async {
  //   var imagesUrl = await Future.wait(images!.map((_image) {
  //     return uploadFiles(
  //       ref,
  //       File(
  //         _image.path,
  //       ),
  //     );
  //   }));

  //   productProvider.getFormData(imagesUrl: imagesUrl);
  //   return imagesUrl;
  // }

  // Future uploadFiles(
  //   String refImage,
  //   File? image,
  // ) async {
  //   Reference refUpload = _storage.ref().child('ProductImages').child(refImage);

  //   UploadTask uploadTask = refUpload.putFile(image!);

  //   await uploadTask;

  //   return refUpload.getDownloadURL();
  // }
}
