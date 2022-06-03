import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
  //userUid
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  //firebase Storage reference
  final ref = FirebaseStorage.instance.ref();
  //
  //init method
  @override
  void initState() {
    super.initState();
    final firestoreInstance =
        FirebaseFirestore.instance.collection("users").doc(userUid);
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
    print('storage reference1');
    // final a = _getString() as String;
    print(_getString());
  }

  _getString() async {
    print('storage reference');
    var ref = await FirebaseStorage.instance
        .ref()
        .child("$userUid/profilePictures/")
        .listAll();
    ref.items.forEach((element) async {
      // element.split('.');
      if (element.name.split('.').first == 'background') {
        profilePageController.setBackgroundImageUrlFromFirebaseStorage(
            (await element.getDownloadURL()).toString());
        // print('getBackgroundImageUrlFromFirebaseStorage $getBackgroundImageUrlFromFirebaseStorage');
      }
      if (element.name.split('.').first == 'profile') {
        profilePageController.setProfileImageUrlFromFirebaseStorage(
            (await element.getDownloadURL()).toString());
        // print('getProfileImageUrlFromFirebaseStorage $getProfileImageUrlFromFirebaseStorage');
      }
    });
    // return ref;
  }

  //variables

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
                    //show backgournd image container
                    Obx(
                      () => ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                        ),
                        child: profilePageController
                                    .getBackgroundImageUrlFromFirebaseStorage
                                    .isNotEmpty &&
                                profilePageController
                                    .getUploadBackgroundImagePath.isEmpty
                            ? CachedNetworkImage(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                fit: BoxFit.fill,
                                imageUrl: profilePageController
                                    .getBackgroundImageUrlFromFirebaseStorage,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 100,
                                  color: Colors.red,
                                ),
                              )
                            : (profilePageController
                                    .getUploadBackgroundImagePath.isNotEmpty)
                                ? Image.file(
                                    File(profilePageController
                                        .getUploadBackgroundImagePath),
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/weighttracker-1234.appspot.com/o/ocean.png?alt=media&token=a3d8ed15-c6d9-4b55-afa4-a6cc4b3c2022',
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  ),
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
                            child: Obx(
                              () => ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: profilePageController
                                            .getProfileImageUrlFromFirebaseStorage
                                            .isNotEmpty &&
                                        profilePageController
                                            .getUploadProfileImagePath.isEmpty
                                    ? CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: profilePageController
                                            .getProfileImageUrlFromFirebaseStorage,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          size: 100,
                                          color: Colors.red,
                                        ),
                                      )
                                    : (profilePageController
                                            .getUploadProfileImagePath
                                            .isNotEmpty)
                                        ? Image.file(
                                            File(profilePageController
                                                .getUploadProfileImagePath),
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/weighttracker-1234.appspot.com/o/profile.png?alt=media&token=432b4bf2-f9a6-4e64-8273-3397f4467583',
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.fill,
                                          ),
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
                            updateMethodButton();
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
    //   uploadBackgroundImage = File(image!.path);
    // });
    // _cropImage(image!.path);
  }

  //
  //crop image
  Future<void> _cropImage(String filepath, String type) async {
    final ImageCropper _cropper = ImageCropper();
    final croppedImage = await _cropper.cropImage(
        sourcePath: filepath,
        compressQuality: 100,
        aspectRatio: type == 'background'
            ? CropAspectRatio(
                ratioX: (MediaQuery.of(context).size.width / 300), ratioY: 1)
            : CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: type == 'background' ? 1080 : 120,
        maxHeight: type == 'background' ? 700 : 120);
    if (croppedImage != null) {
      setState(() {
        type == 'background'
            ? profilePageController
                .setUploadBackgroundImagePath(croppedImage.path)
            : profilePageController
                .setUploadProfileImagePath(croppedImage.path);
        print(
            'patho of image ${profilePageController.getUploadBackgroundImagePath}');
        print(
            'patho of image2 ${profilePageController.getUploadProfileImagePath}');
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

  void updateMethodButton() async {
    if (nameValidate() == true &&
        phoneNumberValidate() == true &&
        aboutValidate() == true) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      final firestoreInstance =
          FirebaseFirestore.instance.collection("users").doc(userUid);
      //for updating or uploading background image
      if (profilePageController.getUploadBackgroundImagePath.isNotEmpty) {
        try {
          String path =
              '$userUid/profilePictures/background.${profilePageController.getUploadBackgroundImagePath.split('.').last}';
          ref.child(path).putFile(
              File(profilePageController.getUploadBackgroundImagePath));
          // Navigator.of(context).popUntil(ModalRoute.withName('/profilePage'));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
          Get.back();
        } catch (e) {
          print(e);
          Get.back();
        }
      }
      //for updating or uploading profile image
      if (profilePageController.getUploadProfileImagePath.isNotEmpty) {
        try {
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // );
          String path =
              '$userUid/profilePictures/profile.${profilePageController.getUploadProfileImagePath.split('.').last}';
          ref
              .child(path)
              .putFile(File(profilePageController.getUploadProfileImagePath));
          // Navigator.of(context).popUntil(ModalRoute.withName('/profilePage'));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
          Get.back();
        } catch (e) {
          print(e);
          Get.back();
        }
      }
      //for updating profile name
      if (nameController.text.split(' ').length == 2) {
        firestoreInstance
            .update({'firstName': nameController.text.split(' ').first});
        firestoreInstance
            .update({'secondName': nameController.text.split(' ').last});
      } else if (nameController.text.split(' ').length == 1) {
        firestoreInstance.update({'firstName': nameController.text});
        firestoreInstance.update({'secondName': ''});
      }
      //for updating profile phoneNumber
      firestoreInstance
          .update({'phoneNumber': int.parse(phoneNumberController.text)});
      //for updating profile about text
      firestoreInstance
          .collection('moreinfo')
          .doc('aboutdata')
          .update({'about': aboutController.text});
      Navigator.of(context).popUntil(ModalRoute.withName('/profilePage'));
    }
  }

  bool nameValidate() {
    if (nameController.text.isEmpty) {
      profilePageController.setNameErrorText('Name cannot be empty');
      return false;
    } else if (nameController.text.length < 6) {
      profilePageController.setNameErrorText('Name must have 6 characters');
      return false;
    } else {
      profilePageController.setNameErrorText('');
      return true;
    }
  }

  bool phoneNumberValidate() {
    if (phoneNumberController.text.isEmpty) {
      profilePageController
          .setPhoneNumberErrorText('Phone Number cannot be empty');
      return false;
    } else if (phoneNumberController.text.length != 10) {
      profilePageController
          .setPhoneNumberErrorText('Phone Number must have 10 digits');
      return false;
    } else {
      profilePageController.setPhoneNumberErrorText('');
      return true;
    }
  }

  bool aboutValidate() {
    if (aboutController.text.isEmpty) {
      profilePageController.setAboutErrorText('About field cannot be empty');
      return false;
    } else if (aboutController.text.length < 251) {
      profilePageController
          .setAboutErrorText('You have to write 250 characters about yourself');
      return false;
    } else {
      profilePageController.setAboutErrorText('');
      return true;
    }
  }
}

class ProfilePageController extends GetxController {
  //
  //error variables
  RxString _nameErrorText = ''.obs;
  RxString _phoneNumberErrorText = ''.obs;
  RxString _aboutErrorText = ''.obs;
  //error variables getters and setters
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

  //
  //imageUrl variables
  RxString _backgroundImageUrlFromFirebaseStorage = ''.obs;
  RxString _profileImageUrlFromFirebaseStorage = ''.obs;
  ////imageUrl variables getters and setters
  String get getBackgroundImageUrlFromFirebaseStorage {
    return _backgroundImageUrlFromFirebaseStorage.value;
  }

  String get getProfileImageUrlFromFirebaseStorage {
    return _profileImageUrlFromFirebaseStorage.value;
  }

  setBackgroundImageUrlFromFirebaseStorage(String value) {
    _backgroundImageUrlFromFirebaseStorage.value = value;
  }

  setProfileImageUrlFromFirebaseStorage(String value) {
    _profileImageUrlFromFirebaseStorage.value = value;
  }

  //
  //uploadimageUrl variables
  RxString _uploadBackgroundImagePath = ''.obs;
  RxString _uploadProfileImagePath = ''.obs;
  //uploadimageUrl variables getters and setters
  String get getUploadBackgroundImagePath {
    return _uploadBackgroundImagePath.value;
  }

  String get getUploadProfileImagePath {
    return _uploadProfileImagePath.value;
  }

  setUploadBackgroundImagePath(String value) {
    _uploadBackgroundImagePath.value = value;
  }

  setUploadProfileImagePath(String value) {
    _uploadProfileImagePath.value = value;
  }
}
