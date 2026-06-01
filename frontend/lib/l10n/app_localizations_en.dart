// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Factory Management';

  @override
  String get navFactories => 'Factories';

  @override
  String get navProducts => 'Products';

  @override
  String get navCategories => 'Categories';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionUpdate => 'Update';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionSave => 'Save';

  @override
  String get actionAdd => 'Add';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get addFactory => 'Add Factory';

  @override
  String get editFactory => 'Edit Factory';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get addModel => 'Add Model';

  @override
  String get addImages => 'Add images';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get fieldFactoryName => 'Factory Name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldWechatId => 'WeChat ID';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldSelectCategory => 'Select Category';

  @override
  String get fieldProductName => 'Product Name';

  @override
  String get fieldModelName => 'Model Name';

  @override
  String get fieldPrice => 'Price';

  @override
  String get fieldInfo => 'Info / Description';

  @override
  String get fieldImages => 'Images';

  @override
  String get fieldCategoryName => 'Category Name';

  @override
  String get fieldRequired => 'Required';

  @override
  String get optional => '(optional)';

  @override
  String get colId => 'ID';

  @override
  String get colName => 'Name';

  @override
  String get colActions => 'Actions';

  @override
  String get colPhone => 'Phone';

  @override
  String get colWechat => 'WeChat';

  @override
  String get colAddress => 'Address';

  @override
  String get colCategory => 'Category';

  @override
  String get colProducts => 'Products';

  @override
  String get colModels => 'Models';

  @override
  String get colPrice => 'Price';

  @override
  String get searchByName => 'Search by name...';

  @override
  String get searchByCategory => 'Search by category...';

  @override
  String get searchByProduct => 'Search by product...';

  @override
  String get filterByFactory => 'Filter by factory';

  @override
  String get allCategories => 'All categories';

  @override
  String get allFactories => 'All factories';

  @override
  String get selectFactory => 'Select factory';

  @override
  String get noData => 'No data found';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get unableToReachServer => 'Unable to reach server';

  @override
  String get checkBackendRunning => 'Check that the backend is running';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this item?';

  @override
  String get deleteCategoryTitle => 'Delete category?';

  @override
  String deleteCategoryMessage(String name) {
    return 'Deleting \"$name\" will permanently remove all factories, products, and models in this category. This cannot be undone.';
  }

  @override
  String get phonePlaceholder => 'e.g. +86123456, +86789012';

  @override
  String get wechatPlaceholder => 'e.g. wechat1, wechat2';

  @override
  String get imagePlaceholder => 'https://example.com/img1.jpg, https://...';

  @override
  String get noProductsAdded => 'No products added.';

  @override
  String get noModelsAdded => 'No models added.';

  @override
  String productN(int n) {
    return 'Product $n';
  }

  @override
  String modelN(int n) {
    return 'Model $n';
  }
}
