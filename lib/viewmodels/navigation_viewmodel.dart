import 'package:steven_asuncion_portfolio/blocs/navigation_bloc.dart';

class NavigationViewModel {
  final NavigationBloc navigationBloc;

  NavigationViewModel({required this.navigationBloc});

  // Current section getter
  NavigationEvent get currentSection =>
      (navigationBloc.state).selectedSection;

  // Navigation methods
  void navigateToProfile() {
    navigationBloc.add(NavigationEvent.profile);
  }

  void navigateToProjects() {
    navigationBloc.add(NavigationEvent.projects);
  }

  // Method to check if a section is currently selected
  bool isSectionSelected(NavigationEvent section) {
    return currentSection == section;
  }

  // Method to get the title for the current section
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

  // Optional: Method to handle deep linking or direct navigation
  void navigateToSection(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'profile':
        navigateToProfile();
        break;
      case 'projects':
        navigateToProjects();
        break;
      default:
        navigateToProfile(); // Default to profile
    }
  }

  // Optional: Method to get the previous section (for back navigation)
  NavigationEvent? getPreviousSection() {
    // Add your logic for maintaining navigation history
    return null;
  }
}
