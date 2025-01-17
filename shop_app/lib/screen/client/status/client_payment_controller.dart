import 'package:flutter/cupertino.dart';
import 'package:shop_app/provider/user_provider.dart';

import '../../../controllers/secure_storage.dart';
import '../../../models/user.dart';
import '../../../provider/push_notifications_provider.dart';

class ClientPaymentStatusController {
  late BuildContext context;
  late Function refresh;
  // GlobalKey<FormState> keyFrom = GlobalKey<FormState>();

  // TextEditingController documentNumberController = TextEditingController();

  // String cardNumber = '';
  // String expireDate = '';
  // String cardHolderName = '';
  // String cvvCode = '';
  // bool isCvvFocused = false;

  // List<MercadoPagoDocumentType> documentTypeList = [];
  // final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  // User? user;

  // String typeDocument = 'CC';

  // String expirationYear = '';
  // int expirationMonth = 0;

  // late MercadoPagoCardToken cardToken;
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();

  final UsersProvider _usersProvider = UsersProvider();

  List<String>? tokens = [];

  late User user;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await SecureStogare().read('user'));
    _usersProvider.init(context, token: user.sessionToken, id: user.id);
    tokens = await _usersProvider.getAdminsNotificationsTokens();
    sendNotification();

    // user = User.fromJson(await SecureStogare().read('user'));

    // _mercadoPagoProvider.init(context, user!);
    // getIdentificationTypes();
  }

  void sendNotification() {
    List<String> registrationIds = [];

    for (String? token in tokens!) {
      if (token != null) {
        registrationIds.add(token);
      }
    }

    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationsProvider.sendMessageMultiple(
      registrationIds,
      data,
      'COMPRA EXITOSA',
      'Un cliente ha realizado un pedido',
    );
  }

  void finishShopping() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/client/products/list',
      (route) => false,
    );
  }

  // void getIdentificationTypes() async {
  // documentTypeList = await _mercadoPagoProvider.getIdentificationTypes();
  // refresh();
}

  // createCardToken() async {
  //   String documentNumber = documentNumberController.text;

  //   if (cardNumber.isEmpty) {
  //     Snackbar.show(context, 'Ingresa el número de la tarjeta');
  //     return;
  //   }
  //   if (expireDate.isEmpty) {
  //     Snackbar.show(context, 'Ingresa la fecha de expiración');
  //     return;
  //   }
  //   if (cvvCode.isEmpty) {
  //     Snackbar.show(context, 'Ingresa el código de seguridad');
  //     return;
  //   }
  //   if (cardHolderName.isEmpty) {
  //     Snackbar.show(context, 'Ingresa el titular de la tarjeta');
  //     return;
  //   }

  //   if (documentNumber.isEmpty) {
  //     Snackbar.show(context, 'Ingresa el número de la tarjeta');
  //     return;
  //   }

  //   if (expireDate != '') {
  //     List<String> list = expireDate.split('/');
  //     if (list.length == 2) {
  //       expirationMonth = int.parse(list[0]);
  //       expirationYear = '20${list[1]}';
  //     } else {
  //       Snackbar.show(
  //         context,
  //         'Inserta el mes y el año de expiración de la tarjeta',
  //       );
  //       return;
  //     }
  //   }

  //   if (cardNumber != '') {
  //     cardNumber = cardNumber.replaceAll(RegExp(' '), '');
  //   }

    // Response? response = await _mercadoPagoProvider.createCardToken(
    //   cvv: cvvCode,
    //   cardNumber: cardNumber,
    //   documentId: typeDocument,
    //   documentNumber: documentNumber,
    //   cardHolderName: cardHolderName,
    //   expirationYear: expirationYear,
    //   expirationMonth: expirationMonth,
    // );

    //   if (response != null) {
    //     final data = json.decode(response.body);

    //     if (response.statusCode == 201) {
    //       cardToken = MercadoPagoCardToken.fromJsonMap(data);
    //       print('CARD TOKEN: ${cardToken.toJson()}');
    //       Navigator.push(
    //         context,
    //         PageRouteBuilder(
    //           pageBuilder: (BuildContext context, Animation<double> animation,
    //               Animation<double> secondaryAnimation) {
    //             return ClientPaymentInstallmentsScreen(
    //               mercadoPagoCardToken: cardToken,
    //               documentNumber: documentNumber,
    //               typeDocument: typeDocument,
    //             );
    //           },
    //           transitionDuration: const Duration(milliseconds: 500),
    //           transitionsBuilder:
    //               (context, animation, secondaryAnimation, child) {
    //             final curvedAnimation =
    //                 CurvedAnimation(parent: animation, curve: Curves.easeInOut);

    //             return FadeTransition(
    //               opacity: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
    //               child: FadeTransition(
    //                 opacity:
    //                     Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
    //                 child: child,
    //               ),
    //             );
    //           },
    //         ),
    //       );
    //     } else {
    //       print('HUBO UN ERROR AL GENERAR EL TOKEN DE LA TARJETA');
    //       int? status = int.tryParse(data['cause'][0]['code'] ?? data['status']);
    //       String message = data['message'] ?? 'Error al registrar la tarjeta';
    //       Snackbar.show(context, 'Status code $status - $message');
    //     }
    //   }
    // }

    // void onCreditCardModelChange(CreditCardModel creditCardModel) {
    //   cardNumber = creditCardModel.cardNumber;
    //   expireDate = creditCardModel.expiryDate;
    //   cardHolderName = creditCardModel.cardHolderName;
    //   cvvCode = creditCardModel.cvvCode;
    //   isCvvFocused = creditCardModel.isCvvFocused;
    //   refresh();
    // }

