
// import 'package:ecocollect/src/screens/onboarding_login.dart';
// import 'package:ecocollect/src/screens/onboarding_screen.dart';
import 'package:ecocollect/src/screens/onboarding_login.dart';
import 'package:ecocollect/src/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
// import '../screens/onboarding_login.dart';
import '../screens/dashboard.dart';
import '../screens/calendar_screen.dart';
import '../screens/tips_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';

enum AppRoute { onboarding, dashboard, calendar, tips, map, profile, onboardingLogin }

class AppRouter extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute>
    implements RouteInformationParser<AppRoute> {

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  AppRoute _current = AppRoute.onboarding;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: OnboardingScreen()),
        if (_current == AppRoute.dashboard) const MaterialPage(child: DashboardScreen()),
        if (_current == AppRoute.calendar)  const MaterialPage(child: CalendarScreen()),
        if (_current == AppRoute.tips)      const MaterialPage(child: TipsScreen()),
        if (_current == AppRoute.map)       const MaterialPage(child: MapScreen()),
        if (_current == AppRoute.profile)   const MaterialPage(child: ProfileScreen()),
        if (_current == AppRoute.onboardingLogin) const MaterialPage(child: OnboardingLoginScreen()),
      ],
      // ignore: deprecated_member_use
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _current = AppRoute.dashboard;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _current = configuration;
  }

  void go(AppRoute route) {
    _current = route;
    notifyListeners();
  }


  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    switch (uri.path) {
      case '/dashboard': return AppRoute.dashboard;
      case '/calendar':  return AppRoute.calendar;
      case '/tips':      return AppRoute.tips;
      case '/map':       return AppRoute.map;
      case '/profile':   return AppRoute.profile;
      default:           return AppRoute.onboarding;
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    switch (configuration) {
      case AppRoute.dashboard: return const RouteInformation(location: '/dashboard');
      case AppRoute.calendar:  return const RouteInformation(location: '/calendar');
      case AppRoute.tips:      return const RouteInformation(location: '/tips');
      case AppRoute.map:       return const RouteInformation(location: '/map');
      case AppRoute.profile:   return const RouteInformation(location: '/profile');
      case AppRoute.onboarding:return const RouteInformation(location: '/onboarding');
      case AppRoute.onboardingLogin: return const RouteInformation(location: '/onboardingLogin');
    }
  }


  @override
  Future<AppRoute> parseRouteInformationWithDependencies(
      RouteInformation routeInformation,
      BuildContext context) {
    return parseRouteInformation(routeInformation);
  }
}


extension AppRouterX on BuildContext {
  AppRouter get routerDelegate =>
      Router.of(this).routerDelegate as AppRouter;
}