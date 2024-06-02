import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati_app/core/constants/assets_images.dart';
import 'package:taskati_app/core/function/routing.dart';
import 'package:taskati_app/core/function/show_error_dialogs.dart';
import 'package:taskati_app/core/services/local_storage.dart';
import 'package:taskati_app/core/widgets/customButton.dart';
import 'package:taskati_app/features/home/presentation/view/home_view.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  String? pathImage;
  TextEditingController nemaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (nemaController.text.isEmpty && pathImage == null) {
                  showErrorDialogs(
                      context: context, text: 'Enter your name and imag');
                } else if (nemaController.text.isNotEmpty &&
                    pathImage == null) {
                  showErrorDialogs(context: context, text: 'Enter your  imag');
                } else if (nemaController.text.isEmpty && pathImage != null) {
                  showErrorDialogs(context: context, text: 'Enter your name');
                } else {
                  AppLocalStorage.cachData(key: 'name',value:  nemaController.text);
                  AppLocalStorage.cachData(key:'image',value:  pathImage);
                  AppLocalStorage.cachData(key:'isUpload',value: true);
                  navigatorToReplacement(context, const HomeView());
                }
              },
              child: const Text('Done'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: (pathImage == null)
                    ? AssetImage(AssetImages.avatar)
                    : FileImage(File(pathImage!)) as ImageProvider,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Upload from Camera',
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              CustomButton(
                text: 'Upload from Gallery',
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
              const Gap(10),
              const Divider(
                endIndent: 25,
                indent: 25,
              ),
              const Gap(20),
              TextFormField(
                controller: nemaController,
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getImage(source) async {
    final ImagePicker pickerImage = ImagePicker();
    XFile? path = await pickerImage.pickImage(source: source);
    if (path != null) {
      setState(() {});
      pathImage = path.path;
    }
  }
}
