class CategoryModel {
  String? categoryId;
  String? description;
  String? name;
  String? image;
  int? productCount;
  int? subCategoriesCount;
  List<SubCategoryModel>? subCategoryModel;

  CategoryModel(
      {this.categoryId,
      this.description,
      this.image,
      this.subCategoriesCount,
      this.productCount,
      this.subCategoryModel,
      this.name});

  Map<String, dynamic> toMap() {
    return {
      "category_id": categoryId,
      "description": description,
      "name": name,
      "image_url": image,
      "product_count": productCount,
      "sub_categories": subCategoryModel?.map((e) => e.toMap()).toList() ?? [],
      "sub_categories_count": subCategoriesCount
    };
  }

  CategoryModel.fromMap(Map<String, dynamic> map)
      : categoryId = map["category_id"],
        description = map["description"],
        productCount = map["product_count"],
        image = map['image_url'],
        subCategoriesCount = map["sub_categories_count"],
        subCategoryModel = (map["sub_categories"] as List)
            .map((e) => SubCategoryModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        name = map["name"];
}

class SubCategoryModel {
  String? id;
  String? description;
  String? name;
  int? productCount;

  SubCategoryModel({this.id, this.description, this.productCount, this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "name": name,
      "product_count": productCount,
    };
  }

  SubCategoryModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        productCount = map["product_count"],
        name = map["name"];
}
