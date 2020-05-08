class FoodItem {
  final String title;
  final String imagePath;
  final List<dynamic> ingredients;
  final List<dynamic> preparation;
  final List<dynamic> category;
  final String kitchen;
  // bool favorite;
  FoodItem(
      {this.title,
      this.imagePath,
      this.category,
      this.kitchen,
      this.ingredients,
      this.preparation});
}
