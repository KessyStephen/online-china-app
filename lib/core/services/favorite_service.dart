import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/favorite.dart';

import 'alert_service.dart';
import 'api.dart';

class FavoriteService {
  final Api _api;
  final AlertService _alertService;

  FavoriteService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  Future<bool> getFavorites({perPage = PER_PAGE_COUNT, page = 1}) async {
    var response = await this._api.getFavorites();
    if (response != null && response['success']) {
      var favoritesArray = response['data'];

      if (favoritesArray.length == 0) {
        return false;
      }

      _favorites.clear();

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

  Future<bool> addToFavorites({productId}) async {
    var response = await this._api.addToFavorites(productId: productId);
    if (response != null && response['success']) {
      _alertService.showAlert(
          text: "Product successfully added to wishlist!", error: false);
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
}
