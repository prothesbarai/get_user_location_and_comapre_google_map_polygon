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

  Future<void> _init() async{
    _storeUserImage = Hive.box("StoreUserImage");
    final storeImage = _storeUserImage.get("store_user_image");
    if(storeImage != null && storeImage is File){
      _profileImage = storeImage;
      notifyListeners();
    }
  }

  
  Future<void> setProfileImage(File image) async{
    _profileImage = image;
    await _storeUserImage.put("store_user_image", image);
    notifyListeners();
  }


  Future<void> clearProfileImage() async {
    _profileImage = null;
    await _storeUserImage.delete("store_user_image");
    notifyListeners();
  }

  
}