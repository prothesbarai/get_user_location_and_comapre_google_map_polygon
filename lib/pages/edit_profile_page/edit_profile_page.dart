import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationcomparewithcoordinates/widgets/custom_app_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  File? cameraImageFile;
  File? galleryImageFile;
  final _picker = ImagePicker();

  void cameraImage() async{
    final pickedImgCamera= await _picker.pickImage(source: ImageSource.camera);
    if(pickedImgCamera != null){
      setState(() {
        cameraImageFile = File(pickedImgCamera.path);
      });
    }
  }


  void galleryImage() async{
    final pickedImgGallery= await _picker.pickImage(source: ImageSource.gallery);
    if(pickedImgGallery != null){
      setState(() {
        galleryImageFile = File(pickedImgGallery.path);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CircleAvatar(
                    radius: 50,
                  ),

                  SizedBox(height: 30,),

                  Row(
                    children: [

                      FloatingActionButton(
                        heroTag: "cameraBtn",
                        onPressed: cameraImage,
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt,color: Colors.white,),
                      ),

                      SizedBox(width: 20,),

                      FloatingActionButton(
                        heroTag: "galleryBtn",
                        onPressed: galleryImage,
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.photo_library_outlined,color: Colors.white,),
                      ),


                    ],
                  )


                ],
              ),
            ],
          )
      ),
    );
  }
}

