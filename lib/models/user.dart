class User {
  int idUser;
  String username;
  String name;
  String nickname;
  String cpf;
  int idProfile;
  String photo;
  String accessToken;

  User(
      {this.idUser,
      this.username,
      this.name,
      this.nickname,
      this.cpf,
      this.idProfile,
      this.photo,
      this.accessToken});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    username = json['username'];
    name = json['name'];
    nickname = json['nickname'];
    cpf = json['cpf'];
    idProfile = json['idProfile'];
    photo = json['photo'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['username'] = this.username;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['cpf'] = this.cpf;
    data['idProfile'] = this.idProfile;
    data['photo'] = this.photo;
    data['accessToken'] = this.accessToken;
    return data;
  }
}