class Kullanici{
  String userId;
  String firstName;
  String lastName;
  String tel;
  String password;
  String registrationDate;

  Kullanici({
    required this.userId,
      required this.firstName,
      required this.lastName,
      required this.tel,
      required this.password,
      required this.registrationDate,
      });

  String getInfo(){
    return "$firstName<>$lastName";
  }


  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'tel': tel,
      'password': password,
      'registrationDate': registrationDate,
    };
  }

  @override
  String toString() {
    return 'Kullanici{firstName: $firstName, lastName: $lastName, tel: $tel, password: $password}';
  }

}