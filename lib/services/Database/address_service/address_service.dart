import 'dart:convert';

import 'package:http/http.dart' as http;

class AddressService {



  Future<List<Map<String, dynamic>>> getAllProvinceVN() async {
    try {
      var url = Uri.https(
          'online-gateway.ghn.vn', 'shiip/public-api/master-data/province');
      var response = await http.post(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch province');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> provinceList = responseBody['data'];

      return provinceList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'ProvinceName': e['ProvinceName'],
            'ProvinceID': e['ProvinceID'],
          };
        },
      ).toList();
    } finally {}
  }

  Future<List<Map<String, dynamic>>> getDistrictOfProvinceVN(
      String provinceID) async {
    try {
      var url = Uri.https(
          'online-gateway.ghn.vn',
          'shiip/public-api/master-data/district',
          {'province_id': provinceID});
      var response = await http.get(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
          // 'token': '056f7ca1-b621-11ef-9b52-ca27b9c74a28',

        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch district');
      }
      print('Response body: ${response.body}');
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> districtList = responseBody['data'];
      print(districtList);

      return districtList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'DistrictName': e['DistrictName'],
            'DistrictID': e['DistrictID'],
          };
        },
      ).toList();
    } finally {}
  }

  Future<List<Map<String, dynamic>>> getWardOfDistrictOfVN(
      String districtID) async {
    try {
      var url = Uri.https('online-gateway.ghn.vn',
          'shiip/public-api/master-data/ward', {'district_id': districtID});
      var response = await http.get(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch ward');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> wardList = responseBody['data'];
      print(wardList);

      return wardList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'WardName': e['WardName'],
            'WardCode': e['WardCode'],
          };
        },
      ).toList();
    } finally {}
  }
}
