// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.htmlAttributions,
    this.nextPageToken,
    this.results,
    this.status,
  });

  List<dynamic> htmlAttributions;
  String nextPageToken;
  List<Result> results;
  String status;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
    nextPageToken: json["next_page_token"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
    "next_page_token": nextPageToken,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "status": status,
  };
}

class Result {
  Result({
    this.businessStatus,
    this.geometry,
    this.icon,
    this.id,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reference,
    this.scope,
    this.types,
    this.userRatingsTotal,
    this.vicinity,
  });

  BusinessStatus businessStatus;
  Geometry geometry;
  String icon;
  String id;
  String name;
  OpeningHours openingHours;
  List<Photo> photos;
  String placeId;
  PlusCode plusCode;
  int priceLevel;
  double rating;
  String reference;
  Scope scope;
  List<Type> types;
  int userRatingsTotal;
  String vicinity;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    businessStatus: businessStatusValues.map[json["business_status"]],
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    id: json["id"],
    name: json["name"],
    openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    placeId: json["place_id"],
    plusCode: PlusCode.fromJson(json["plus_code"]),
    priceLevel: json["price_level"] == null ? null : json["price_level"],
    rating: json["rating"].toDouble(),
    reference: json["reference"],
    scope: scopeValues.map[json["scope"]],
    types: List<Type>.from(json["types"].map((x) => typeValues.map[x])),
    userRatingsTotal: json["user_ratings_total"],
    vicinity: json["vicinity"],
  );

  Map<String, dynamic> toJson() => {
    "business_status": businessStatusValues.reverse[businessStatus],
    "geometry": geometry.toJson(),
    "icon": icon,
    "id": id,
    "name": name,
    "opening_hours": openingHours == null ? null : openingHours.toJson(),
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "place_id": placeId,
    "plus_code": plusCode.toJson(),
    "price_level": priceLevel == null ? null : priceLevel,
    "rating": rating,
    "reference": reference,
    "scope": scopeValues.reverse[scope],
    "types": List<dynamic>.from(types.map((x) => typeValues.reverse[x])),
    "user_ratings_total": userRatingsTotal,
    "vicinity": vicinity,
  };
}

enum BusinessStatus { OPERATIONAL }

final businessStatusValues = EnumValues({
  "OPERATIONAL": BusinessStatus.OPERATIONAL
});

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location location;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "viewport": viewport.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location northeast;
  Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}

class OpeningHours {
  OpeningHours({
    this.openNow,
  });

  bool openNow;

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["open_now"],
  );

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
  };
}

class Photo {
  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    height: json["height"],
    htmlAttributions: List<String>.from(json["html_attributions"].map((x) => x)),
    photoReference: json["photo_reference"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
    "photo_reference": photoReference,
    "width": width,
  };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String compoundCode;
  String globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}

enum Scope { GOOGLE }

final scopeValues = EnumValues({
  "GOOGLE": Scope.GOOGLE
});

enum Type { RESTAURANT, FOOD, POINT_OF_INTEREST, STORE, ESTABLISHMENT, BAR }

final typeValues = EnumValues({
  "bar": Type.BAR,
  "establishment": Type.ESTABLISHMENT,
  "food": Type.FOOD,
  "point_of_interest": Type.POINT_OF_INTEREST,
  "restaurant": Type.RESTAURANT,
  "store": Type.STORE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
