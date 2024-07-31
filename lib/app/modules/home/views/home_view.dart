import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/auth_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData iconData;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = 'Add Products';
              iconData = Icons.post_add;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 1:
              title = 'Products';
              iconData = Icons.list_alt;
              onTap = () {
                Get.toNamed(Routes.products);
              };
              break;
            case 2:
              title = 'QR Code';
              iconData = Icons.qr_code;
              onTap = () async {
              String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "Cancel",
                  true,
                  ScanMode.QR,
                );
                Map<String, dynamic> hasil= await controller.getProductById(barcode);
                if (hasil['error'] == false) {
                  Get.toNamed(Routes.detailProduct, arguments: barcode);
                } else {
                  Get.snackbar('Error', hasil['message']);
                }
              };
              break;
            case 3:
              title = 'Catalog';
              iconData = Icons.document_scanner_outlined;
              onTap = () {
                controller.downloadCatalog();
              };
              break;
          }

          return Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red[300],
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                onTap();
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        iconData,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
              ),
          ),
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async{
          Map<String, dynamic> result = await authC.logout();

          if (result['error'] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar(
              'Tidak dapat logout',
              result['message'],
              backgroundColor: Colors.red,
            );
          }
        },
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }
}
