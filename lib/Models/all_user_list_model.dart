class AllUserListModel {
  bool? success;
  List<Data>? data;
  String? message;

  AllUserListModel({this.success, this.data, this.message});

  AllUserListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? email;
  String? username;
  String? picture;
  String? isPremium;
  int? remainingDays;
  String? package;

  Data(
      {this.id,
      this.email,
      this.username,
      this.picture,
      this.isPremium,
      this.remainingDays,
      this.package});

  Data.fromJson(Map<String, dynamic> json) {
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
