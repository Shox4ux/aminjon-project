// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Factory Management';

  @override
  String get navFactories => 'Zavodlar';

  @override
  String get navProducts => 'Mahsulotlar';

  @override
  String get navCategories => 'Kategoriyalar';

  @override
  String get actionCreate => 'Yaratish';

  @override
  String get actionCancel => 'Bekor qilish';

  @override
  String get actionUpdate => 'Yangilash';

  @override
  String get actionDelete => 'O\'chirish';

  @override
  String get actionEdit => 'Tahrirlash';

  @override
  String get actionSave => 'Saqlash';

  @override
  String get actionAdd => 'Qo\'shish';

  @override
  String get lightMode => 'Yorug\' rejim';

  @override
  String get darkMode => 'Qorong\'u rejim';

  @override
  String get addFactory => 'Zavod qo\'shish';

  @override
  String get editFactory => 'Zavodini tahrirlash';

  @override
  String get addProduct => 'Mahsulot qo\'shish';

  @override
  String get editProduct => 'Mahsulotni tahrirlash';

  @override
  String get addModel => 'Model qo\'shish';

  @override
  String get addImages => 'Rasm qo\'shish';

  @override
  String get addCategory => 'Kategoriya qo\'shish';

  @override
  String get editCategory => 'Kategoriyani tahrirlash';

  @override
  String get fieldFactoryName => 'Zavod nomi';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldWechatId => 'WeChat ID';

  @override
  String get fieldAddress => 'Manzil';

  @override
  String get fieldCategory => 'Kategoriya';

  @override
  String get fieldSelectCategory => 'Kategoriya tanlang';

  @override
  String get fieldProductName => 'Mahsulot nomi';

  @override
  String get fieldModelName => 'Model nomi';

  @override
  String get fieldPrice => 'Narx';

  @override
  String get fieldInfo => 'Ma\'lumot / Tavsif';

  @override
  String get fieldImages => 'Rasmlar';

  @override
  String get fieldCategoryName => 'Kategoriya nomi';

  @override
  String get fieldRequired => 'Majburiy';

  @override
  String get optional => '(ixtiyoriy)';

  @override
  String get colId => 'ID';

  @override
  String get colName => 'Nomi';

  @override
  String get colActions => 'Amallar';

  @override
  String get colPhone => 'Telefon';

  @override
  String get colWechat => 'WeChat';

  @override
  String get colAddress => 'Manzil';

  @override
  String get colCategory => 'Kategoriya';

  @override
  String get colProducts => 'Mahsulotlar';

  @override
  String get colModels => 'Modellar';

  @override
  String get colPrice => 'Narx';

  @override
  String get searchByName => 'Nomi bo\'yicha qidirish...';

  @override
  String get searchByCategory => 'Kategoriya bo\'yicha qidirish...';

  @override
  String get searchByProduct => 'Mahsulot bo\'yicha qidirish...';

  @override
  String get filterByFactory => 'Zavod bo\'yicha filtr';

  @override
  String get allCategories => 'Barcha kategoriyalar';

  @override
  String get allFactories => 'Barcha zavodlar';

  @override
  String get selectFactory => 'Zavod tanlang';

  @override
  String get noData => 'Ma\'lumot topilmadi';

  @override
  String get errorOccurred => 'Xatolik yuz berdi';

  @override
  String get unableToReachServer => 'Serverga ulanib bo\'lmadi';

  @override
  String get checkBackendRunning => 'Backend ishga tushganligini tekshiring';

  @override
  String get confirmDeleteTitle => 'O\'chirishni tasdiqlang';

  @override
  String get confirmDeleteMessage =>
      'Ushbu elementni o\'chirishni xohlaysizmi?';

  @override
  String get deleteCategoryTitle => 'Kategoriyani o\'chirish?';

  @override
  String deleteCategoryMessage(String name) {
    return '\"$name\" o\'chirilsa, shu kategoriya ostidagi barcha zavodlar, mahsulotlar va modellar ham o\'chiriladi. Bu amalni qaytarib bo\'lmaydi.';
  }

  @override
  String get phonePlaceholder => 'mas. +86123456, +86789012';

  @override
  String get wechatPlaceholder => 'mas. wechat1, wechat2';

  @override
  String get imagePlaceholder => 'https://example.com/img1.jpg, https://...';

  @override
  String get noProductsAdded => 'Mahsulotlar qo\'shilmagan.';

  @override
  String get noModelsAdded => 'Modellar qo\'shilmagan.';

  @override
  String productN(int n) {
    return '$n-mahsulot';
  }

  @override
  String modelN(int n) {
    return '$n-model';
  }
}
