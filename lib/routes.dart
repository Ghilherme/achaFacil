import 'package:AchaFacil/screens/home/home_screen.dart';
import 'package:AchaFacil/screens/profile/profile.dart';
import 'package:AchaFacil/screens/search/search.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  /* SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(), */
  HomeScreen.routeName: (context) => HomeScreen(),
  Profile.routeName: (context) => Profile(),
  Search.routeName: (context) => Search(),
};
