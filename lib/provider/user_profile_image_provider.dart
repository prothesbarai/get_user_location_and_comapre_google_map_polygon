import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserProfileImageProvider extends ChangeNotifier{
  File? _profileImage;
  late Box _storeUserImage;

  File? get profileImage => _profileImage;

  UserProfileImageProvider() {
    _init();
  }



  Future<void> setProfileImage(File image) async{
    _profileImage = image;
    await _storeUserImage.put("store_user_image", image.path);
    notifyListeners();
  }



  Future<void> _init() async{
    _storeUserImage = Hive.box("StoreUserImage");
    final path = _storeUserImage.get("store_user_image_path");
    if (path != null && path is String) {
      final file = File(path);
      if (await file.exists()) {
        _profileImage = file;
        notifyListeners();
      }
    }
  }



  Future<void> clearProfileImage() async {
    _profileImage = null;
    await _storeUserImage.delete("store_user_image");
    notifyListeners();
  }

  
}