import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text("Location App",style: TextStyle(color: Colors.white),),
      centerTitle: true,
      actions: [

        
        
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_vert),
        )
        
      ],
    );
  }
}
