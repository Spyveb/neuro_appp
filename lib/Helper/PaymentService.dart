import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';

class PaymentService {
  /// We want singelton object of ``PaymentService`` so create private constructor
  ///
  /// Use PaymentService as ``PaymentService.instance``
  PaymentService._internal();

  factory PaymentService() {
    return instance;
  }

  String premiumtoken = "";
  String subdevice = "";

  static final PaymentService instance = PaymentService._internal();

  /// To listen the status of connection between app and the billing server
  late StreamSubscription<ConnectionResult> _connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  StreamSubscription<void>? _purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  StreamSubscription<void>? _purchaseErrorSubscription;

  /// List of product ids you want to fetch
  final List<String> _productIds = Platform.isAndroid
      ? ['android.test.purchased']
      : ['com.neuropal.premium'];

  /// All available products will be store in this list
  List<IAPItem> _products = [];

  List<PurchasedItem> _purchasedSub = [];

  /// All past purchases will be store in this list
  List<PurchasedItem> _pastPurchases = [];

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  ObserverList<Function> _proStatusChangedListeners =
      new ObserverList<Function>();

  /// view of the app will subscribe to this to get errors of the purchase
  ObserverList<Function(String)> _errorListeners =
      new ObserverList<Function(String)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUser => _isProUser;

  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

  /// view can subscribe to _errorListeners using this method
  addToErrorListeners(Function(String) callback) {
    _errorListeners.add(callback);
  }

  /// view can cancel to _errorListeners using this method
  removeFromErrorListeners(Function(String) callback) {
    _errorListeners.remove(callback);
  }

  void _callProStatusChangedListeners() {
    _proStatusChangedListeners.forEach((Function callback) {
      callback();
    });
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String error) {
    _errorListeners.forEach((Function callback) {
      callback(error);
    });
  }

  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initialize();

    _getSubscriptionStatus();
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {});

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);
    _getItems();
    //_getPastPurchases();
    //_getPURCAHSEHISTORY();
  }

  Future<void> _getSubscriptionStatus() async {
    final String url = "${GlobalConfiguration().get("api_base_url")}varifydate";
    print("$url");
    var token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Constant.TOKEN)) {
      token = prefs.getString(Constant.TOKEN)!;
    }
    Uri myUri = Uri.parse(url);
    final client = new http.Client();
    final response = await client.get(
      myUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      var res = json.decode(response.body);
      await prefs.setBool(Constant.ISPRIME, res['data']['isPrime']);
    } else {
      await prefs.setBool(Constant.ISPRIME, false);
      print(response.body.toString());
    }
  }

  /// call when user close the app
  void dispose() {
    _connectionSubscription.cancel();
    _purchaseErrorSubscription!.cancel();
    _purchaseUpdatedSubscription!.cancel();
    FlutterInappPurchase.instance.finalize();
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    _callErrorListeners(purchaseError!.message!);
  }

  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (Platform.isAndroid) {
      await _handlePurchaseUpdateAndroid(productItem!);
    } else {
      await _handlePurchaseUpdateIOS(productItem!);
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
        // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem);
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
  /// 0 : UNSPECIFIED_STATE
  /// 1 : PURCHASED
  /// 2 : PENDING
  Future<void> _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {
    switch (purchasedItem.purchaseStateAndroid) {
      case PurchaseState.purchased:
        if (purchasedItem.isAcknowledgedAndroid!) {
          await _verifyAndFinishTransaction(purchasedItem);
        }
        break;
      default:
        _callErrorListeners("Something went wrong");
    }
  }

  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
    bool isValid = false;
    try {
      // Call API
      isValid = await _verifyPurchase(purchasedItem);
    } on Exception {
      _callErrorListeners("Something went wrong");
      return;
    }

    if (isValid) {
      FlutterInappPurchase.instance.finishTransaction(purchasedItem);
      _isProUser = true;
      // save in sharedPreference here
      _callProStatusChangedListeners();
    } else {
      _callErrorListeners("Varification failed");
    }
  }

  Future<List<IAPItem>> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products;
  }

  Future<void> _getItems() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(_productIds);
    _products = [];
    for (var item in items) {
      this._products.add(item);
    }
  }

  Future<void> _getPURCAHSEHISTORY() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    _purchasedSub = [];
    for (var item in items!) {
      print(item.toString());
      this._purchasedSub.add(item);
    }
  }

  void _getPastPurchases() async {
    // remove this if you want to restore past purchases in iOS
    if (Platform.isIOS) {
      return;
    }
    List<PurchasedItem>? purchasedItems =
        await FlutterInappPurchase.instance.getAvailablePurchases();

    for (var purchasedItem in purchasedItems!) {
      bool isValid = false;

      if (Platform.isAndroid) {
        Map map = json.decode(purchasedItem.transactionReceipt!);
        // if your app missed finishTransaction due to network or crash issue
        // finish transactins
        if (!map['acknowledged']) {
          isValid = await _verifyPurchase(purchasedItem);
          if (isValid) {
            FlutterInappPurchase.instance.finishTransaction(purchasedItem);
            _isProUser = true;
            _callProStatusChangedListeners();
          }
        } else {
          _isProUser = true;
          _callProStatusChangedListeners();
        }
      }
    }

    _pastPurchases = [];
    _pastPurchases.addAll(purchasedItems);
  }

  Future<Null> buyProduct(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestSubscription(item.productId!);
    } catch (error) {}
  }

  _verifyPurchase(PurchasedItem purchasedItem) {
    if (Platform.isAndroid) {
      premiumtoken = purchasedItem.purchaseToken!;
      subdevice = "android";
    } else {
      premiumtoken = purchasedItem.transactionReceipt!;
      subdevice = "ios";
    }
    return true;
  }

  validateReceipt(PurchasedItem purchasedItem) async {
    var receiptBody = {
      'receipt-data': purchasedItem.transactionReceipt!,
      'password': '768562b001394807bded3b0758d24aec'
    };
    final result = await FlutterInappPurchase.instance
        .validateReceiptIos(receiptBody: receiptBody, isTest: true);
    print(result.body.toString());
  }
}
