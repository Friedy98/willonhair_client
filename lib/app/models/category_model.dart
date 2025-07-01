import 'package:flutter/material.dart';
import 'parents/model.dart';

class Category extends Model {
  String id;
  String name;
  String description;
  Color color;
  bool featured;
  List<Category> subCategories;

  Category({this.id, this.name, this.description, this.color, this.featured, this.subCategories});

  Category.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    featured = boolFromJson(json, 'featured');
    subCategories = listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          featured == other.featured &&
          subCategories == other.subCategories;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ featured.hashCode ^ subCategories.hashCode;
}
