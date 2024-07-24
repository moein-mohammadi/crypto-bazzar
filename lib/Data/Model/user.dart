class User {
  int id;
  String name;
  String username;
  String city;
  String phone;
  User(this.id, this.city, this.name, this.phone, this.username);
  factory User.fromMapJison(Map<String, dynamic> jsonObjeect) {
    return User(
      jsonObjeect['id'],
      jsonObjeect['address']['city'],
      jsonObjeect['name'],
      jsonObjeect['phone'],
      jsonObjeect['username'],
    );
  }

}
