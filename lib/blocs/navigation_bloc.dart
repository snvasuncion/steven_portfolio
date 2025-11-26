import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvent { profile, projects, about, contact }

class NavigationState {
  final NavigationEvent selectedSection;
  NavigationState(this.selectedSection);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(NavigationEvent.profile)) {
    on<NavigationEvent>((event, emit) {
      emit(NavigationState(event));
    });
  }
}
