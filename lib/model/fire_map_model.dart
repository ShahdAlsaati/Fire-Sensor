class FireModel {
  String? message;
  List<int>? codes;
  List<Fires>? fires;

  FireModel({this.message, this.codes, this.fires});

  FireModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codes = json['codes'].cast<int>();
    if (json['fires'] != null) {
      fires = <Fires>[];
      json['fires'].forEach((v) { fires!.add(Fires.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['codes'] = this.codes;
    if (this.fires != null) {
      data['fires'] = this.fires!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fires {
  int? fireId;
  Fire? fire;
  String? startAt;
  String? endedAt;
  bool? active;

  Fires({this.fireId, this.fire, this.startAt, this.endedAt, this.active});

  Fires.fromJson(Map<String, dynamic> json) {
    fireId = json['fireId'];
    fire = json['fire'] != null ? Fire.fromJson(json['fire']) : null;
    startAt = json['startAt'];
    endedAt = json['endedAt'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fireId'] = this.fireId;
    if (this.fire != null) {
      data['fire'] = this.fire!.toJson();
    }
    data['startAt'] = this.startAt;
    data['endedAt'] = this.endedAt;
    data['active'] = this.active;
    return data;
  }
}

class Fire {
  int? radius;
  Center? center;

  Fire({this.radius, this.center});

  Fire.fromJson(Map<String, dynamic> json) {
    radius = json['radius'];
    center = json['center'] != null ? Center.fromJson(json['center']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['radius'] = this.radius;
    if (this.center != null) {
      data['center'] = this.center!.toJson();
    }
    return data;
  }
}

class Center {
  double? latitude;
  double? longitude;

  Center({this.latitude, this.longitude});

  Center.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
