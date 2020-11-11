class User {
  final int id;
  final String imageUrl;
  final String name;
  final String phone;
  final String address;
  final String company;
  final String email;
  final String license;
  final String truckModel;
  final String truckNumber;
  final String duty;
  final String joinDate;
  final String drivingSince;

  User({
    this.id,
    this.name,
    this.phone,
    this.license,
    this.joinDate,
    this.address,
    this.company,
    this.imageUrl,
    this.email,
    this.duty,
    this.truckModel,
    this.truckNumber,
    this.drivingSince
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
    // return User(
      id: data["driverid"],
      name: data["drivername"],
      license: data["license"],
      company: data["companycode"],
      address: data["address"],
      imageUrl: data["img"],
      duty: data["dutyclass"],
      email: data["email"],
      joinDate: data["dateofjoining"],
      phone: data["phone"],
      truckModel: data["truckmodel"],
      truckNumber: data["drivercell"],
      drivingSince: data["drivingsince"]
    // );
  );
}
