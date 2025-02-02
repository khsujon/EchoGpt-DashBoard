class DashboardDataModel {
  bool? success;
  Data? data;
  String? message;

  DashboardDataModel({this.success, this.data, this.message});

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? totalUser;
  int? totalChatMessage;
  List<LatestFiveuser>? latestFiveuser;

  Data({this.totalUser, this.totalChatMessage, this.latestFiveuser});

  Data.fromJson(Map<String, dynamic> json) {
    totalUser = json['totalUser'];
    totalChatMessage = json['totalChatMessage'];
    if (json['latestFiveuser'] != null) {
      latestFiveuser = <LatestFiveuser>[];
      json['latestFiveuser'].forEach((v) {
        latestFiveuser!.add(new LatestFiveuser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalUser'] = this.totalUser;
    data['totalChatMessage'] = this.totalChatMessage;
    if (this.latestFiveuser != null) {
      data['latestFiveuser'] =
          this.latestFiveuser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LatestFiveuser {
  String? id;
  String? email;
  String? username;
  String? picture;
  String? isPremium;
  int? remainingDays;
  String? package;

  LatestFiveuser(
      {this.id,
      this.email,
      this.username,
      this.picture,
      this.isPremium,
      this.remainingDays,
      this.package});

  LatestFiveuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    picture = json['picture'];
    isPremium = json['isPremium'];
    remainingDays = json['remainingDays'];
    package = json['package'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['picture'] = this.picture;
    data['isPremium'] = this.isPremium;
    data['remainingDays'] = this.remainingDays;
    data['package'] = this.package;
    return data;
  }
}
