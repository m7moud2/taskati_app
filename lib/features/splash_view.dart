import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati_app/core/constants/assets_images.dart';
import 'package:taskati_app/core/function/routing.dart';
import 'package:taskati_app/core/services/local_storage.dart';
import 'package:taskati_app/features/home/presentation/view/home_view.dart';
import 'package:taskati_app/features/upload/upload_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late bool isUpload;
  @override
  void initState() {
    super.initState();
    isUpload = AppLocalStorage.getCachData(key: 'isUpload') ?? false;
    Future.delayed(const Duration(seconds: 4), () {
      navigatorToReplacement(
          context, (isUpload == true) ? const HomeView() : const UploadView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetImages.appIcon),
        ],
      ),
    ));
  }
}
