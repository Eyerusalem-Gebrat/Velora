class User {
  final int id;
  final String email;
  final String username;
  final String firstname;
  final String lastname;
  final String city;
  final String street;
  final String zipcode;
  final String phone;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.street,
    required this.zipcode,
    required this.phone,
  });

  String get fullName {
    final first = firstname.isNotEmpty
        ? '${firstname[0].toUpperCase()}${firstname.substring(1)}'
        : '';
    final last = lastname.isNotEmpty
        ? '${lastname[0].toUpperCase()}${lastname.substring(1)}'
        : '';
    return '$first $last'.trim();
  }

  String get fullAddress {
    final parts = [street, city, zipcode].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final nameObj = json['name'] as Map<String, dynamic>?;
    final addressObj = json['address'] as Map<String, dynamic>?;

    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstname: nameObj?['firstname'] as String? ?? '',
      lastname: nameObj?['lastname'] as String? ?? '',
      city: addressObj?['city'] as String? ?? '',
      street: addressObj?['street'] as String? ?? '',
      zipcode: addressObj?['zipcode'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': {
        'firstname': firstname,
        'lastname': lastname,
      },
      'address': {
        'city': city,
        'street': street,
        'zipcode': zipcode,
      },
      'phone': phone,
    };
  }
}
