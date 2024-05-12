class RouteModel {
  final String name;
  final String path;

  const RouteModel({required this.name, required this.path});
}

class Routes {
  static const RouteModel signin = RouteModel(
    name: 'signin',
    path: '/signin',
  );
  static const RouteModel signup = RouteModel(
    name: 'signup',
    path: '/signup',
  );
  static const RouteModel resetPassword = RouteModel(
    name: 'resetPassword',
    path: '/resetPassword',
  );
  static const RouteModel verifyEmail = RouteModel(
    name: 'verifyEmail',
    path: '/verifyEmail',
  );
  static const RouteModel splash = RouteModel(
    name: 'splash',
    path: '/splash',
  );
  static const RouteModel firebaseError = RouteModel(
    name: 'firebaseError',
    path: '/firebaseError',
  );

  static const RouteModel home = RouteModel(
    name: 'home',
    path: '/home',
  );
  static const RouteModel changePassword = RouteModel(
    name: 'changePassword',
    path: 'changePassword',
  );
}
