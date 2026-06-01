// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Factory Management';

  @override
  String get navFactories => 'Заводы';

  @override
  String get navProducts => 'Продукты';

  @override
  String get navCategories => 'Категории';

  @override
  String get actionCreate => 'Создать';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionUpdate => 'Обновить';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get lightMode => 'Светлая тема';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get addFactory => 'Добавить завод';

  @override
  String get editFactory => 'Редактировать завод';

  @override
  String get addProduct => 'Добавить продукт';

  @override
  String get editProduct => 'Редактировать продукт';

  @override
  String get addModel => 'Добавить модель';

  @override
  String get addImages => 'Добавить изображения';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get fieldFactoryName => 'Название завода';

  @override
  String get fieldPhone => 'Телефон';

  @override
  String get fieldWechatId => 'WeChat ID';

  @override
  String get fieldAddress => 'Адрес';

  @override
  String get fieldCategory => 'Категория';

  @override
  String get fieldSelectCategory => 'Выберите категорию';

  @override
  String get fieldProductName => 'Название продукта';

  @override
  String get fieldModelName => 'Название модели';

  @override
  String get fieldPrice => 'Цена';

  @override
  String get fieldInfo => 'Информация / Описание';

  @override
  String get fieldImages => 'Изображения';

  @override
  String get fieldCategoryName => 'Название категории';

  @override
  String get fieldRequired => 'Обязательное поле';

  @override
  String get optional => '(необязательно)';

  @override
  String get colId => 'ID';

  @override
  String get colName => 'Название';

  @override
  String get colActions => 'Действия';

  @override
  String get colPhone => 'Телефон';

  @override
  String get colWechat => 'WeChat';

  @override
  String get colAddress => 'Адрес';

  @override
  String get colCategory => 'Категория';

  @override
  String get colProducts => 'Продукты';

  @override
  String get colModels => 'Модели';

  @override
  String get colPrice => 'Цена';

  @override
  String get searchByName => 'Поиск по названию...';

  @override
  String get searchByCategory => 'Поиск по категории...';

  @override
  String get searchByProduct => 'Поиск по продукту...';

  @override
  String get filterByFactory => 'Фильтр по заводу';

  @override
  String get allCategories => 'Все категории';

  @override
  String get allFactories => 'Все заводы';

  @override
  String get selectFactory => 'Выберите завод';

  @override
  String get noData => 'Данные не найдены';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get unableToReachServer => 'Невозможно подключиться к серверу';

  @override
  String get checkBackendRunning => 'Убедитесь, что бэкенд запущен';

  @override
  String get confirmDeleteTitle => 'Подтвердить удаление';

  @override
  String get confirmDeleteMessage =>
      'Вы уверены, что хотите удалить этот элемент?';

  @override
  String get deleteCategoryTitle => 'Удалить категорию?';

  @override
  String deleteCategoryMessage(String name) {
    return 'Удаление \"$name\" безвозвратно удалит все заводы, продукты и модели в этой категории.';
  }

  @override
  String get phonePlaceholder => 'напр. +86123456, +86789012';

  @override
  String get wechatPlaceholder => 'напр. wechat1, wechat2';

  @override
  String get imagePlaceholder => 'https://example.com/img1.jpg, https://...';

  @override
  String get noProductsAdded => 'Продукты не добавлены.';

  @override
  String get noModelsAdded => 'Модели не добавлены.';

  @override
  String productN(int n) {
    return 'Продукт $n';
  }

  @override
  String modelN(int n) {
    return 'Модель $n';
  }
}
