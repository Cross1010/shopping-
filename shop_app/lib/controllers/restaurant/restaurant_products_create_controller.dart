import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/product.dart';

import 'package:shop_app/provider/category_provider.dart';

import '../../models/user.dart';
import '../../widgets/widgets.dart';

class RestaurantProductsCreateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BuildContext? context;

  bool isLoading = false;

  late Function refresh;

  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  TextEditingController priceController = TextEditingController(text: '0.00');

  final CategoryProvider _categoryProvider = CategoryProvider();

  List<Category> categories = [];
  String? idCategory; //TO SAVE CATEGORY ID SELECT
  final ImagePicker _picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    User user = User.fromJson(await SecureStogare().read('user'));
    _categoryProvider.init(context, user.sessionToken, user.id!);
    getCategories();
  }

  void getCategories() async {
    categories = await _categoryProvider.getAll();

    refresh();
  }

  void createProduct() async {
    if (formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      String price = priceController.text.trim();

      if (imageFile1 != null && imageFile2 != null && imageFile3 != null) {
        if (idCategory != null) {
          Product product = Product(
              name: title,
              description: description,
              price: double.parse(price),
              idCategory: int.parse(idCategory!),
              quantity: 10);

          print(product.toJson());
        } else {
          Snackbar.show(context, 'Selecciona la categoría del producto');
          return;
        }
      } else {
        Snackbar.show(context, 'Selecciona las tres imagenes');
        return;
      }

      print(title);
      print(description);
      print(price);
    }
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    final XFile? image = await _picker.pickImage(source: imageSource);

    if (numberFile == 1) {
      if (image != null) {
        imageFile1 = File(image.path);
        refresh();
      }
    }

    if (numberFile == 2) {
      if (image != null) {
        imageFile2 = File(image.path);
        refresh();
      }
    }

    if (numberFile == 3) {
      if (image != null) {
        imageFile3 = File(image.path);
        refresh();
      }
    }

    Navigator.pop(context!);
  }

  void showAlertDialog(int numberFile) {
    Widget galleyButton = MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        selectImage(ImageSource.gallery, numberFile);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        height: 100,
        width: 100,
        child: Icon(
          Icons.image,
          size: MediaQuery.of(context!).size.height * 0.1,
        ),
      ),
    );

    Widget cameraButton = MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        selectImage(ImageSource.camera, numberFile);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        height: 100,
        width: 100,
        child: Icon(
          Icons.camera_alt_outlined,
          size: MediaQuery.of(context!).size.height * 0.1,
        ),
      ),
    );

    Widget alertDialog = AlertDialog(
      alignment: Alignment.center,
      content: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cameraButton,
            galleyButton,
          ],
        ),
      ),
    );

    showDialog(
        context: context!,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(
      context!,
      '/roles',
      (route) => false,
    );
  }
}
