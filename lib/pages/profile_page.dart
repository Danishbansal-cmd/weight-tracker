import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try1_something/functions/my_drawer.dart';
import 'package:try1_something/utils/themes.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //
  //initializing controller
  final profilePageController = Get.put(ProfilePageController());
  //
  //init method
  @override
  void initState() {
    super.initState();
    final firestoreInstance = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    firestoreInstance
        .collection('moreinfo')
        .doc('aboutdata')
        .get()
        .then((value) {
      aboutController.text = value['about'];
    });
    firestoreInstance.get().then((value) {
      nameController.text = value['firstName'] + ' ' + value['secondName'];
      phoneNumberController.text = value['phoneNumber'].toString();
    });
  }

  File? pathOfImage;
  File? pathOfImage2;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode aboutNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();

  final decorationFormFields = const InputDecoration(
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
  );

  @override
  Widget build(BuildContext context) {
    // nameController.text = Get.arguments['name'];
    // phoneNumberController.text = Get.arguments['phoneNumber'];
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Profile",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 16,
      //     ),
      //   ),
      // ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //background image and
                //profile image STACK
                Stack(
                  children: [
                    //
                    //a container to provide the widht and height
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 380,
                    ),
                    //
                    //show image container
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13),
                      ),
                      child: (pathOfImage != null)
                          ? Image.file(
                              pathOfImage!,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'assets/ocean.png',
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              fit: BoxFit.fill,
                            ),
                    ),
                    //
                    //show background image change button
                    Positioned(
                      right: 20,
                      bottom: 100,
                      child: InkWell(
                        onTap: () async {
                          await _getFromGallery(type: 'background');
                        },
                        child: changeImageButton(),
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
                          //white background main box
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white),
                          ),
                          //
                          //profile image box
                          Positioned(
                            top: 5,
                            left: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: (pathOfImage2 != null)
                                  ? Image.file(
                                      pathOfImage2!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          //
                          //change profile image box
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9),
                              onTap: () async {
                                await _getFromGallery(type: 'profile');
                              },
                              child: changeImageButton(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    //NAME box
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: SizedBox(
                        height: 80,
                        width:
                            (MediaQuery.of(context).size.width - 40 - 130 - 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            //name
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                  40 -
                                  130 -
                                  10 -
                                  50),
                              child: TextFormField(
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                      fontSize: 26,
                                      letterSpacing: -0.5,
                                      color: Colors.black,
                                    ),
                                focusNode: emailNode,
                                controller: nameController,
                                decoration: decorationFormFields.copyWith(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    profilePageController.setNameErrorText(
                                        'Name cannot be empty');
                                  } else if (value.length < 7) {
                                    profilePageController.setNameErrorText(
                                        'Name must have 6 characters');
                                  } else {
                                    profilePageController.setNameErrorText('');
                                  }
                                },
                              ),
                            ),
                            //
                            //edit button
                            InkWell(
                              onTap: () {
                                if (emailNode.hasFocus == false) {
                                  FocusScope.of(context)
                                      .requestFocus(emailNode);
                                } else if (emailNode.hasFocus == true) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: editButton(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                    //BACK button
                    Positioned(
                      top: MediaQuery.of(context).viewPadding.top + 20,
                      left: 20,
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: iconBox(Icons.keyboard_backspace_outlined)),
                    ),
                    //
                    //NAME error text
                    Positioned(
                      bottom: 12,
                      left: (20 + 130 + 10),
                      child: Obx(
                        () => Visibility(
                          visible:
                              profilePageController.getNameErrorText.isNotEmpty,
                          child: Text(
                            profilePageController.getNameErrorText,
                            style: MyThemes.errorStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                //
                //EMAIL column
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      //
                      //email icon box
                      iconBox(CupertinoIcons.mail_solid),
                      const SizedBox(
                        width: 15,
                      ),
                      //
                      //email value
                      SizedBox(
                        width: (MediaQuery.of(context).size.width -
                                40 - // around spaces
                                40 - // icon box
                                15 - // space
                                20 // extra margin
                            ),
                        child: Text(Get.arguments['email'],
                            style: MyThemes.font16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //
                //PHONENUMBER column
                Stack(
                  children: [
                    //
                    //MAIN DATA box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              //
                              //phone number icon box
                              iconBox(CupertinoIcons.phone_fill),
                              const SizedBox(
                                width: 15,
                              ),
                              //
                              //phone number
                              SizedBox(
                                width: (MediaQuery.of(context).size.width -
                                        40 - // around spaces
                                        40 - // icon box
                                        40 - // edit button
                                        15 - // space
                                        10 - // space
                                        20 // extra margin
                                    ),
                                child: TextFormField(
                                  style: MyThemes.font16,
                                  focusNode: phoneNumberNode,
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'))
                                  ],
                                  decoration: decorationFormFields.copyWith(),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      profilePageController
                                          .setPhoneNumberErrorText(
                                              'Phone Number cannot be empty');
                                    } else if (value.length != 10) {
                                      profilePageController
                                          .setPhoneNumberErrorText(
                                              'Phone Number must have 10 digits');
                                    } else {
                                      profilePageController
                                          .setPhoneNumberErrorText('');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          //
                          //edit button
                          InkWell(
                            onTap: () {
                              if (phoneNumberNode.hasFocus == false) {
                                FocusScope.of(context)
                                    .requestFocus(phoneNumberNode);
                              } else if (phoneNumberNode.hasFocus == true) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            child: editButton(),
                          ),
                        ],
                      ),
                    ),
                    //
                    //PHONE error text
                    Positioned(
                      left: (20 + 40 + 15),
                      bottom: 2,
                      child: Obx(
                        () => Visibility(
                          visible: profilePageController
                              .getPhoneNumberErrorText.isNotEmpty,
                          child: Text(
                            profilePageController.getPhoneNumberErrorText,
                            style: MyThemes.errorStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                //
                //ABOUT column
                Stack(
                  children: [
                    //
                    //ABOUT DATA box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          //
                          //first column
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //about text
                              Text(
                                'About',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              //icon box
                              InkWell(
                                onTap: () {
                                  if (aboutNode.hasFocus == false) {
                                    FocusScope.of(context)
                                        .requestFocus(aboutNode);
                                  } else if (aboutNode.hasFocus == true) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: editButton(),
                              ),
                            ],
                          ),
                          //
                          //second column
                          TextFormField(
                            style: MyThemes.font16,
                            controller: aboutController,
                            focusNode: aboutNode,
                            maxLines: null,
                            maxLength: 1000,
                            decoration: decorationFormFields.copyWith(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                profilePageController.setAboutErrorText(
                                    'About field cannot be empty');
                              } else if (value.length < 251) {
                                profilePageController.setAboutErrorText(
                                    'You have to write 250 characters about yourself');
                              } else {
                                profilePageController.setAboutErrorText('');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    //
                    //ABOUT error text
                    Positioned(
                      left: (20),
                      bottom: 2,
                      child: Obx(
                        () => Visibility(
                          visible: profilePageController
                              .getAboutErrorText.isNotEmpty,
                          child: Text(
                            profilePageController.getAboutErrorText,
                            style: MyThemes.errorStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                //
                //UPDATE Button
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ).copyWith(bottom: 20),
                  child: Material(
                    borderRadius: BorderRadius.circular(13),
                    color: Color(0xff673AB7),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      splashColor: MyThemes.splashColor1,
                      onTap: () {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () {
                            if (_formKey.currentState!.validate()) {}
                          },
                        );
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
        ),
      ),
    );
  }

  //
  // Get from gallery
  Future<void> _getFromGallery({required String type}) async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (image != null) {
      _cropImage(image.path, type);
    }
    // setState(() {
    //   pathOfImage = File(image!.path);
    // });
    // _cropImage(image!.path);
  }

  //
  //crop image
  Future<void> _cropImage(String filepath, String type) async {
    final ImageCropper _cropper = ImageCropper();
    final croppedImage = await _cropper.cropImage(
        sourcePath: filepath,
        maxWidth: type == 'background' ? 1080 : 120,
        maxHeight: type == 'background' ? 700 : 120);
    if (croppedImage != null) {
      setState(() {
        type == 'background'
            ? pathOfImage = File(croppedImage.path)
            : pathOfImage2 = File(croppedImage.path);
      });
    }
  }

  Future<void> readImageFromFirebase() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
  }

  Widget editButton() {
    return Container(
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
              'assets/icons/edit.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget iconBox(IconData iconData) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 24,
        ),
      ),
    );
  }

  Widget changeImageButton() {
    return Container(
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
    );
  }
}

class ProfilePageController extends GetxController {
  RxString _nameErrorText = ''.obs;
  RxString _phoneNumberErrorText = ''.obs;
  RxString _aboutErrorText = ''.obs;

  setNameErrorText(String value) {
    _nameErrorText.value = value;
  }

  setPhoneNumberErrorText(String value) {
    _phoneNumberErrorText.value = value;
  }

  setAboutErrorText(String value) {
    _aboutErrorText.value = value;
  }

  String get getNameErrorText {
    return _nameErrorText.value;
  }

  String get getPhoneNumberErrorText {
    return _phoneNumberErrorText.value;
  }

  String get getAboutErrorText {
    return _aboutErrorText.value;
  }
}
