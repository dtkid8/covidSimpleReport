class Corona {
  final DateTime last_updated;
  final int latest;
  final List<Location> locations;
  Corona({this.last_updated, this.latest, this.locations});
  factory Corona.fromJson(Map<String, dynamic> json) {
    List<Location> locations = (json['locations'] as List).map((i) => Location.fromJson(i)).toList();
    locations.sort((a, b) => a.country.compareTo(b.country));
    return Corona(
      last_updated: DateTime.tryParse(json['last_updated'] ?? ''),
      latest: json['latest'] as int,
      locations: locations,
    );
  }
}

class Location {
  final Coordinate coordinate;
  final List<History> history;
  final String country;
  final String country_code;
  final int latest;
  final String province;
  Location({this.coordinate, this.history, this.country, this.country_code, this.latest, this.province});
  factory Location.fromJson(Map<String, dynamic> json) {
    String zeroGenerator(String temp) {
      if (int.parse(temp) <= 9) {
        return temp = "0$temp";
      } else {
        return temp;
      }
    }

    String dateFormat(String temp) {
      List<String> date = temp.split('/');
      if (date.isNotEmpty) {
        String day = zeroGenerator(date[1]);
        String month = zeroGenerator(date[0]);
        String year = "20${date[2]}";
        return temp = "$year-$month-$day 00:00:00";
      }
    }

    List<History> history = [];
    for (var key in json['history'].keys) {
      //print(dateFormat(key) + "ASDADSADS");
      history.add(History(
        date: DateTime.tryParse(dateFormat(key)),
        victim: json['history'][key] as int,
      ));
    }
    if (history.isNotEmpty) {
      history.sort((b, a) => a.date.compareTo(b.date));
    }
    return Location(
      coordinate: Coordinate.fromJson(json["coordinates"]),
      history: history,
      country: json['country'],
      country_code: json['country_code'],
      latest: json['latest'] as int,
      province: json['province'],
    );
  }
}

class Coordinate {
  final String lat;
  final String long;
  Coordinate({this.lat, this.long});
  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }
}

class History {
  final DateTime date;
  final int victim;
  History({this.date, this.victim});
}
