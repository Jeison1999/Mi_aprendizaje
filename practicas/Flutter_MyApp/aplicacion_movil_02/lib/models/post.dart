import 'dart:convert';

class User {
  int? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? website;
  Address? address;
  Company? company;
  User(response) {
    Map<String, dynamic> map = jsonDecode(response);
    id = map['id'];
    name = map['name'];
    username = map['username'];
    email = map['email'];
    phone = map['phone'];
    website = map['website'];
    company = Company(map['company']);
    address = Address(map['address']);
  }
}

class Address {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Geo? geo;

  Address(Map map) {
    street = map['street'];
    suite = map['suite'];
    city = map['city'];
    zipcode = map['zipcode'];
    geo = Geo(map['geo']);
  }

  @override
  String toString() {
    return '''
street: $street 
suite: $suite
city: $city
zipcode: $zipcode
''';
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo(Map geo) {
    lat = geo['lat'];
    lng = geo['lng'];
  }
  @override
  String toString() {
    return '''
lat: $lat
lng: $lng
    ''';
  }
}

class Company {
  String? name;
  String? catchPhrase;
  String? bs;

  Company(Map company) {
    name = company['name'];
    catchPhrase = company['catchPhrase'];
    bs = company['bs'];
  }

  @override
  String toString() {
    return '''
name: $name
catchPhrase: $catchPhrase,
bs: $bs
    ''';
  }
}
