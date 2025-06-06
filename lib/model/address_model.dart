class AddressModel {
  final String? id;
  final String province;
  final String district;
  final String ward;
  final String provinceId;
  final String districtId;
  final String wardCode;
  final double? lat;
  final double? lng;

  AddressModel({
    this.id,
    required this.province,
    required this.district,
    required this.ward,
    required this.provinceId,
    required this.districtId,
    required this.wardCode,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'province': province,
      'district': district,
      'ward': ward,
      'provinceId': provinceId,
      'districtId': districtId,
      'wardCode': wardCode,
      'lat': lat,
      'lng': lng,
    };
  }
  factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
    return AddressModel(
      id: id,
      province: map['province'],
      district: map['district'],
      ward: map['ward'],
      provinceId: map['provinceId'],
      districtId: map['districtId'],
      wardCode: map['wardCode'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }
}
