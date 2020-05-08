import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/data/categories.dart';
import 'package:home_of_food/data/food_data.dart';
import 'package:home_of_food/data/kitchens.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:home_of_food/pages/food_list/widgets/food_list_card.dart';
import 'package:home_of_food/widgets/divider.dart';

class SearchTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchTabState();
  }
}

class SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();
  String selectedKitchen = 'المطبخ';
  String selectedCategory = 'التصنيف';
  List<FoodItem> foodList = [];
  bool searching = true;
  bool noRusluts = true;
  

  Future<bool> search(String title, kitchen, category) async {
    var categoryItems;
    // case 1
    if (title.isNotEmpty && kitchen != 'المطبخ' && category != 'التصنيف') {
      categoryItems = foodData.where((e) =>
          e['kitchen'] == kitchen &&
          (e['category'] as List).contains(category) &&
          (e['title'] as String).contains(title));
      // case 2
    } else if (title.isNotEmpty &&
        kitchen != 'المطبخ' &&
        category == 'التصنيف') {
      categoryItems = foodData.where((e) =>
          e['kitchen'] == kitchen && (e['title'] as String).contains(title));
      // case 3
    } else if (title.isNotEmpty &&
        kitchen == 'المطبخ' &&
        category != 'التصنيف') {
      categoryItems = foodData.where((e) =>
          (e['category'] as List).contains(category) &&
          (e['title'] as String).contains(title));
      // case 4
    } else if (title.isEmpty && kitchen != 'المطبخ' && category != 'التصنيف') {
      categoryItems = foodData.where((e) =>
          e['kitchen'] == kitchen &&
          (e['category'] as List).contains(category));
      // case 5
    } else if (title.isNotEmpty &&
        kitchen == 'المطبخ' &&
        category == 'التصنيف') {
      categoryItems =
          foodData.where((e) => (e['title'] as String).contains(title));
      // case 6
    } else if (title.isEmpty && kitchen != 'المطبخ' && category == 'التصنيف') {
      categoryItems = foodData.where((e) => (e['kitchen'] == kitchen));
      // case 7
    } else if (title.isEmpty && kitchen == 'المطبخ' && category != 'التصنيف') {
      categoryItems =
          foodData.where((e) => ((e['category'] as List).contains(category)));
    } else {
      return false;
    }

    foodList.clear();
    for (var item in categoryItems.toList()) {
      FoodItem foodItem = FoodItem(
        title: item['title'],
        kitchen: item['kitchen'],
        imagePath: item['image_path'],
        category: item['category'],
        ingredients: item['ingredients'],
        preparation: item['preparation'],
      );
      foodList.add(foodItem);
    }
    return foodList.length > 0 ? true : false;
  }

  Widget searchText(context) {
    return Row(children: <Widget>[
      RaisedButton(
        color: blue,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: black)),
        child: Text(
          'بحث',
          style: TextStyle(
              color: black, fontSize: 18, fontWeight: FontWeight.w900),
        ),
        onPressed: () async {
          setState(() {
            searching = true;
            noRusluts = false;
          });
          bool isThereRuslts = await search(
              searchController.text, selectedKitchen, selectedCategory);
          setState(() {
            searching = false;
            noRusluts = !isThereRuslts;
          });
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 40,
        decoration: BoxDecoration(
            color: lightPink, borderRadius: BorderRadius.circular(50)),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: 15.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            suffix: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.search,
                size: 20,
                color: lightBlue,
              ),
            ),
            hintText: 'عن ماذا تبحث؟',
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w900, color: black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          searchText(context),
          Row(
            children: <Widget>[
              RaisedButton(
                color: blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: black)),
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconEnabledColor: pink,
                      iconSize: 30,
                      style: TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 3.0,
              ),
              RaisedButton(
                color: blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: black)),
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconEnabledColor: pink,
                      iconSize: 30,
                      style: TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900),
                      value: selectedKitchen,
                      onChanged: (value) {
                        setState(() {
                          selectedKitchen = value;
                        });
                      },
                      items: kitchens
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          DividerV2(),
          noRusluts
              ? Text(
                  'لا توجد نتائج للبحث',
                  style: TextStyle(fontSize: 16, color: black),
                )
              : searching
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: foodList.length,
                          itemBuilder: (context, index) {
                            FoodItem foodItem = FoodItem(
                              title: foodList[index].title,
                              kitchen: foodList[index].kitchen,
                              imagePath: foodList[index].imagePath,
                              category: foodList[index].category,
                              ingredients: foodList[index].ingredients,
                              preparation: foodList[index].preparation,
                            );
                            return FoodListCard(
                              foodItem: foodItem,
                            );
                          }),
                    )
        ],
      ),
    );
  }
}

//  Container(
//                 decoration: BoxDecoration(
//                     color: blue,
//                     borderRadius: BorderRadius.circular(18.0),
//                     border: Border()),
//                 child: DropdownButton(
//                   // style: ,
//                   value: 'One',
//                   onChanged: (value) {},
//                   items: <String>['One', 'Two', 'Free', 'Four']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ),
