import 'package:flutter_meals_app/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum Filter {
  glutenFree,
  lactoseFree,
  vegeterian,
  vegan
}

class FiltersNotifier extends StateNotifier<Map<Filter,bool>>{
  FiltersNotifier() : super({
    Filter.glutenFree : false,
    Filter.lactoseFree : false,
    Filter.vegan : false,
    Filter.vegeterian : false,
  });

  void setFilters(Map<Filter,bool> chosenFilters){
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive){
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier,Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);


final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((element) {
      if (activeFilters[Filter.glutenFree]! && !element.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !element.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegeterian]! && !element.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !element.isVegan) {
        return false;
      }
      return true;
    }).toList();
});