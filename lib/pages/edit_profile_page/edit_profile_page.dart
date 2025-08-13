import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationcomparewithcoordinates/widgets/custom_app_bar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/user_profile_image_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  File? profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final imageProvider = Provider.of<UserProfileImageProvider>(context, listen: false);

      final pickFile = await _imagePicker.pickImage(source: source);
      if (pickFile == null) return;


      // Original Image File Size Print
      int originalSize = await File(pickFile.path).length();
      if (kDebugMode) {
        print("Original Image Size: ${originalSize / 1024} KB");
      }


      /// >>> Crop Image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            hidesNavigationBar: false,
            aspectRatioPickerButtonHidden: false,
            minimumAspectRatio: 1.0,
          ),
        ],
      );


      // >>> If Not Crop Image Stop Here
      if (croppedFile == null) return;


      // >>> Print cropped file size
      int croppedSize = await File(croppedFile.path).length();
      if (kDebugMode) {
        print("Cropped Image Size: ${croppedSize / 1024} KB");
      }


      /// >>> Compressed To ~300KB
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final compressedFile = await FlutterImageCompress.compressAndGetFile(croppedFile.path, targetPath, quality: 70, minWidth: 512, minHeight: 512,);

      if (compressedFile == null) return;

      // >>> Print compressed file size
      int compressedSize = await compressedFile.length();
      if (kDebugMode) {
        print("Compressed Image Size: ${compressedSize / 1024} KB");
      }


      int fileSize = await compressedFile.length();
      if (fileSize > (300 * 1024)) {
        // Try compress again if larger than 300KB
        final compressedAgain = await FlutterImageCompress.compressAndGetFile(croppedFile.path, targetPath, quality: 50, minWidth: 512, minHeight: 512,);
        if (compressedAgain != null) {
          profileImage = File(compressedAgain.path);
          setState((){});
          await imageProvider.setProfileImage(profileImage!);
        }
      } else {
        profileImage = File(compressedFile.path);
        setState((){});
        await imageProvider.setProfileImage(profileImage!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Image pick/crop/compress error: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    final imageProvider = Provider.of<UserProfileImageProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  PhysicalModel(
                    color: Colors.transparent,
                    elevation: 6,
                    shape: BoxShape.circle,
                    shadowColor: Colors.black54,
                    child: CircleAvatar(
                      radius: 150,
                      backgroundColor: Colors.blue,
                      backgroundImage: imageProvider.profileImage != null ? FileImage(imageProvider.profileImage!) : (profileImage != null) ? FileImage(profileImage!) : null,
                      child: (profileImage == null && imageProvider.profileImage == null) ? Icon(Icons.person, size: 50, color: Colors.white) : null,
                    ),
                  ),


                  SizedBox(height: 30,),

                  Row(
                    children: [

                      FloatingActionButton(
                        heroTag: "cameraBtn",
                        onPressed: ()=>pickImage(ImageSource.camera),
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt,color: Colors.white,),
                      ),

                      SizedBox(width: 20,),

                      FloatingActionButton(
                        heroTag: "galleryBtn",
                        onPressed: ()=>pickImage(ImageSource.gallery),
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.photo_library_outlined,color: Colors.white,),
                      ),


                    ],
                  ),

                  SizedBox(height: 20,),


                  if(imageProvider.profileImage != null)...[
                    ElevatedButton(
                        onPressed: (){
                          imageProvider.clearProfileImage();
                        },
                        child: Text("Remove Profile Image")
                    )
                  ]


                ],
              ),
            ],
          )
      ),
    );
  }
}

