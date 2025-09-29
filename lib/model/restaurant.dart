class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String? address;
  final double rating;
  final List<Category> categories;
  final Menus? menus;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    this.address,
    required this.rating,
    this.categories = const [],
    this.menus,
    this.customerReviews = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    pictureId: json['pictureId'],
    city: json['city'],
    address: json['address'], // bisa null kalau dari /list
    rating: (json['rating'] as num).toDouble(),
    categories:
    (json['categories'] as List?)
        ?.map((c) => Category.fromJson(c))
        .toList() ??
        [],
    menus: json['menus'] != null ? Menus.fromJson(json['menus']) : null,
    customerReviews:
    (json['customerReviews'] as List?)
        ?.map((r) => CustomerReview.fromJson(r))
        .toList() ??
        [],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'address': address,
      'rating': rating,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pictureId: map['pictureId'],
      city: map['city'],
      address: map['address'],
      rating: (map['rating'] as num).toDouble(),
    );
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name']);
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: (json['foods'] as List).map((f) => MenuItem.fromJson(f)).toList(),
    drinks: (json['drinks'] as List).map((d) => MenuItem.fromJson(d)).toList(),
  );
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      MenuItem(name: json['name']);
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json['name'],
    review: json['review'],
    date: json['date'],
  );
}
