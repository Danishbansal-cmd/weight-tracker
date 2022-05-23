import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try1_something/functions/my_drawer.dart';
import 'package:try1_something/utils/themes.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? pathOfImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            //background image and
            //profile image STACK
            Stack(
              children: [
                //
                //a container to provide the widht and height
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      // border: Border.,
                      ),
                ),
                //
                //show image container
                if (pathOfImage != null)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13),
                      ),
                      image: DecorationImage(
                        image: FileImage(pathOfImage!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                //
                //show background image change button
                Positioned(
                  right: 20,
                  bottom: 90,
                  child: InkWell(
                    onTap: () async {
                      await _getFromGallery();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset(
                              'assets/icons/gallery.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //show profile image
                //and change image button
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Stack(
                    children: [
                      //
                      //show profile image box
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      //
                      //change profile image box
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.asset(
                                  'assets/icons/gallery.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //
            //testing getimage from firebase storage

            //
            //UPDATE Button
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(bottom: 30),
              child: Material(
                borderRadius: BorderRadius.circular(13),
                color: Color(0xff673AB7),
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  splashColor: MyThemes.splashColor1,
                  onTap: (){
                    Future.delayed(const Duration(milliseconds: 100),(){
                      print('update');
                    },);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    child: Center(
                      child: Text(
                        "UPDATE",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  /// Get from gallery
  Future<void> _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      pathOfImage = File(image!.path);
    });
    // _cropImage(image!.path);
  }

  Future<void> readImageFromFirebase() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
  }
}
