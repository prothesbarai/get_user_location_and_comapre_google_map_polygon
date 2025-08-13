import 'package:flutter/material.dart';
import 'package:locationcomparewithcoordinates/pages/edit_profile_page/edit_profile_page.dart';
import 'package:locationcomparewithcoordinates/utils/app_color.dart';
import 'package:provider/provider.dart';

import '../provider/user_profile_image_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final imageProvider = Provider.of<UserProfileImageProvider>(context);

    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: Stack(
        children: [

          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: SweepGradient(
                      colors: AppColor.colorArray,
                      center: AlignmentDirectional(1, -1),
                      stops: [0.0, 0.2, 0.2, 0.3, 0.3, 0.4,0.4,0.6,0.6,8.0,8.0,0.9,1.0],
                      startAngle: 0.9,
                      endAngle: 6,
                    )
                ),
              ),
              Container(color: Colors.black.withValues(alpha: 0.6),)
            ],
          ),

          ListView(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: UnderlineTabIndicator(borderSide: BorderSide.none),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(),));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        backgroundImage: (imageProvider.profileImage) != null ? FileImage(imageProvider.profileImage!) : null,
                        child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 50, color: Colors.white) : null,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Name",style: TextStyle(color: Colors.white),),
                          Text("012xxxxxxxxxxxx",style: TextStyle(color: Colors.white),)

                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),


        ],
      ),


    );
  }
}
