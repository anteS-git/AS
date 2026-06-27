class Recipe {
  final String title;
  final String ingredients;
  final String servings;
  final String instructions;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.servings,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? 'Nepoznat recept',
      ingredients: json['ingredients'] ?? '',
      servings: json['servings'] ?? '1',
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'servings': servings,
      'instructions': instructions,
    };
  }

  String get uniqueKey => '${title}_$servings';
}

class DailyMeal {
  final String naziv;
  final String opis;
  final String kategorija;

  DailyMeal({
    required this.naziv,
    required this.opis,
    required this.kategorija,
  });
}
