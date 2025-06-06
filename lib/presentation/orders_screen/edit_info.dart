import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/model/address_model.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/services/Database/address_service/address_repository.dart';
import 'package:untitled/services/Database/address_service/address_service.dart';
import 'package:untitled/services/Database/user_service.dart';
import 'package:untitled/theme/custom_text_style.dart';
import 'package:untitled/widgets/custom_elevated_button.dart';
import 'package:untitled/widgets/custom_text_form_field.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key, required this.user});

  final CustomUser user;

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  late AddressService addressService;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  List<Map<String, dynamic>>? provinces;
  List<Map<String, dynamic>>? districts;
  List<Map<String, dynamic>>? wards;

  String? currentProvinceId;
  String? currentProvinceName;
  String? currentDistrictId;
  String? currentDistrictName;
  String? currentWardCode;
  String? currentWardName;

  late AddressRepository addressRepository;

  @override
  void initState() {
    super.initState();
    addressService = AddressService();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    addressRepository = AddressRepository();

    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final data = await addressService.getAllProvinceVN();
      setState(() {
        provinces = data;
      });
    } catch (e) {
      print("Error loading provinces: $e");
    }
  }

  Future<void> _loadDistricts(String provinceId) async {
    try {
      final data = await addressService.getDistrictOfProvinceVN(provinceId);
      setState(() {
        districts = data;
        currentDistrictId = null;
        currentDistrictName = null;
        wards = null;
        currentWardCode = null;
        currentWardName = null;
      });
    } catch (e) {
      print("Error loading districts: $e");
    }
  }

  Future<void> _loadWards(String districtId) async {
    try {
      final data = await addressService.getWardOfDistrictOfVN(districtId);
      setState(() {
        wards = data;
        currentWardCode = null;
        currentWardName = null;
      });
    } catch (e) {
      print("Error loading wards: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildDropdown({
    required String? currentValue,
    required List<Map<String, dynamic>>? items,
    required String hintText,
    required Function(String value) onChanged,
    required String displayKey,
    required String valueKey,
  }) {
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return DropdownButtonFormField<String>(
      value: currentValue,
      hint: Text(hintText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          )),
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item[valueKey].toString(),
          child: Text(
            item[displayKey],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) => onChanged(value!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Information')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name',
                  style: CustomTextStyles.bodyMediumLightBlue
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              CustomTextFormField(
                controller: _nameController,
                hintText: "Enter your name",
                textInputType: TextInputType.text,
                contentPadding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 16),
              Text('Phone',
                  style: CustomTextStyles.bodyMediumLightBlue
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              CustomTextFormField(
                controller: _phoneController,
                hintText: 'Phone',
                contentPadding: const EdgeInsets.all(12),
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              Text('Address',
                  style: CustomTextStyles.bodyMediumLightBlue
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildDropdown(
                currentValue: currentProvinceId,
                items: provinces,
                hintText: 'Select Province',
                displayKey: 'ProvinceName',
                valueKey: 'ProvinceID',
                onChanged: (value) {
                  setState(() {
                    currentProvinceId = value;
                    currentProvinceName = provinces!.firstWhere(
                            (province) =>
                        province['ProvinceID'].toString() == value)['ProvinceName'];
                    currentDistrictId = null;
                    currentDistrictName = null;
                    currentWardCode = null;
                    currentWardName = null;
                    districts = null;
                    wards = null;
                  });
                  _loadDistricts(currentProvinceId!);
                },
              ),
              const SizedBox(height: 16),
              if (currentProvinceId != null)
                _buildDropdown(
                  currentValue: currentDistrictId,
                  items: districts,
                  hintText: 'Select District',
                  displayKey: 'DistrictName',
                  valueKey: 'DistrictID',
                  onChanged: (value) {
                    setState(() {
                      currentDistrictId = value;
                      currentDistrictName = districts!.firstWhere(
                              (district) =>
                          district['DistrictID'].toString() == value)['DistrictName'];
                      currentWardCode = null;
                      currentWardName = null;
                      wards = null;
                    });
                    _loadWards(currentDistrictId!);
                  },
                ),
              if (currentDistrictId != null) const SizedBox(height: 16),
              if (currentDistrictId != null)
                _buildDropdown(
                  currentValue: currentWardCode,
                  items: wards,
                  hintText: 'Select Ward',
                  displayKey: 'WardName',
                  valueKey: 'WardCode',
                  onChanged: (value) {
                    setState(() {
                      currentWardCode = value;
                      currentWardName = wards!.firstWhere(
                              (ward) => ward['WardCode'].toString() == value)['WardName'];
                    });
                  },
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Update',
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      ProfileService()
                          .updateUserName(widget.user.uid!, _nameController.text);
                    }
                    if (_phoneController.text.isNotEmpty) {
                      ProfileService().updateUserPhone(
                          widget.user.uid!, _phoneController.text);
                    }
                    if (widget.user.addressId == null) {
                      AddressModel address = AddressModel(
                        province: currentProvinceName!,
                        district: currentDistrictName!,
                        ward: currentWardName!,
                        provinceId: currentProvinceId!,
                        districtId: currentDistrictId!,
                        wardCode: currentWardCode!,
                      );
                      addressRepository.createAddressAndLinkToUser(
                          address, widget.user.uid!);
                      print('Chưa có địa chỉ, tạo mới');
                    } else {
                      AddressModel address = AddressModel(
                        id: widget.user.addressId,
                        province: currentProvinceName!,
                        district: currentDistrictName!,
                        ward: currentWardName!,
                        provinceId: currentProvinceId!,
                        districtId: currentDistrictId!,
                        wardCode: currentWardCode!,
                      );
                      addressRepository.updateAddress(widget.user.addressId!, address);
                    }

                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
