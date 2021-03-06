import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/services/secure_storage_service.dart';

import 'alert_service.dart';
import 'api.dart';

class FavoriteService {
  final Api _api;
  final AlertService _alertService;
  final SecureStorageService _storageService;

  FavoriteService(
      {@required Api api,
      @required AlertService alertService,
      @required SecureStorageService storageService})
      : _api = api,
        _alertService = alertService,
        _storageService = storageService;

  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  Future<bool> getFavorites({perPage = PER_PAGE_COUNT, page = 1}) async {
    String accessToken = await _storageService.getAccessToken();
    if (accessToken == null) {
      return false;
    }

    var response = await this._api.getFavorites();

    _favorites.clear();

    if (response != null && response['success']) {
      var favoritesArray = response['data'];

      if (favoritesArray.length == 0) {
        return false;
      }

      for (int i = 0; i < favoritesArray.length; i++) {
        _favorites.add(Favorite.fromJson(favoritesArray[i]));
      }

      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<String> addToFavorites({productId}) async {
    var response = await this._api.addToFavorites(productId: productId);
    if (response != null && response['success']) {
      _alertService.showAlert(
          text: "Product successfully added to wishlist!", error: false);
      return response["id"];
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return null;
    }
  }

  Future<bool> deleteFromFavorites({favoriteId}) async {
    var response = await this._api.deleteFromFavorites(favoriteId: favoriteId);
    if (response != null && response['success']) {
      _alertService.showAlert(
          text: "Product successfully removed from wishlist!", error: false);
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<Favorite> getFavoriteForProduct({productId}) async {
    Favorite result;

    for (var item in _favorites) {
      if (item.product != null && item.product.id == productId) {
        result = item;
        break;
      }
    }

    return result;
  }
}
