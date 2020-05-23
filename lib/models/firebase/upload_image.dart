import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImage(File image) async {
  String path =
      "users_food_images/" + image.path.split('/')[image.path.split('/').length - 1];

  final StorageReference storageReference = FirebaseStorage().ref().child(path);
  final StorageUploadTask uploadTask =
      storageReference.putData(await image.readAsBytes());
  var value = await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = value.toString();
  return url;
}