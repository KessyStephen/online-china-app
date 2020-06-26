import 'package:flutter/cupertino.dart';

import 'authentication_service.dart';

class StartUpService {
  final AuthenticationService _authenticationService;

  StartUpService(
      {@required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<bool> handleStartUplogic() async {
    bool hasLoggedInUser = await _authenticationService.checkIfUserIsLoggedIn();
    await this.addUserToStream();
    return hasLoggedInUser;
  }

  Future<bool> addUserToStream() async {
    return await _authenticationService.addUserToStream();
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    return await _authenticationService.checkIfUserIsLoggedIn();
  }
}
