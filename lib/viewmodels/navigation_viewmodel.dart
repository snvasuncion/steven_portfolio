import 'package:steven_asuncion_portfolio/blocs/navigation_bloc.dart';

class NavigationViewModel {
  final NavigationBloc navigationBloc;

  NavigationViewModel({required this.navigationBloc});

  NavigationEvent get currentSection => (navigationBloc.state).selectedSection;

  void navigateToProfile() {
    navigationBloc.add(NavigationEvent.profile);
  }

  void navigateToProjects() {
    navigationBloc.add(NavigationEvent.projects);
  }

  bool isSectionSelected(NavigationEvent section) {
    return currentSection == section;
  }

  String getCurrentSectionTitle() {
    switch (currentSection) {
      case NavigationEvent.profile:
        return 'Profile';
      case NavigationEvent.projects:
        return 'Projects';
      default:
        return 'Portfolio';
    }
  }

  void navigateToSection(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'profile':
        navigateToProfile();
        break;
      case 'projects':
        navigateToProjects();
        break;
      default:
        navigateToProfile();
    }
  }

  NavigationEvent? getPreviousSection() {
    return null;
  }
}
