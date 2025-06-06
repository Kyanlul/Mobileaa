
class CustomUser {
  final String? uid;
  String? name;
  String? email;
  String? pass;
  String? phone;
  bool? isSeller;
  String? addressId;
  String? avatar_link =
      'https://m.media-amazon.com/images/I/41V5FtEWPkL._SX300_SY300_QL70_FMwebp_.jpg';
  String? bio;
  final String? nationality;
  final String? gender;
  final bool? acceptedTerms;
  final bool? acceptedMarketing;

  CustomUser({
    this.uid,
    this.name,
    this.email,
    this.pass,
    this.phone,
    this.isSeller,
    this.addressId,
    this.avatar_link =
        'https://m.media-amazon.com/images/I/41V5FtEWPkL._SX300_SY300_QL70_FMwebp_.jpg',
    this.bio,
    this.nationality,
    this.gender,
    this.acceptedTerms,
    this.acceptedMarketing,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'pass': pass,
      'phone': phone,
      'isSeller': isSeller,
      'addressId': addressId,
      'avatar_link': avatar_link,
      'bio': bio,
      'nationality': nationality,
      'gender': gender,
      'acceptedTerms': acceptedTerms,
      'acceptedMarketing': acceptedMarketing,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      pass: map['pass'],
      phone: map['phone'],
      isSeller: map['isSeller'] ?? false,
      addressId: map['addressId'],
      avatar_link: map['avatar_link'],
      bio: map['bio'],
      nationality: map['nationality'] ?? '',
      gender: map['gender'] ?? '',
      acceptedTerms: map['acceptedTerms'] ?? false,
      acceptedMarketing: map['acceptedMarketing'] ?? false,
    );
  }
}
