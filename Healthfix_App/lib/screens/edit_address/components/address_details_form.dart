import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/Address.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';
import 'package:string_validator/string_validator.dart';

import '../../../constants.dart';

class AddressDetailsForm extends StatefulWidget {
  final Address addressToEdit;

  AddressDetailsForm({
    Key key,
    this.addressToEdit,
  }) : super(key: key);

  @override
  _AddressDetailsFormState createState() => _AddressDetailsFormState();
}

class _AddressDetailsFormState extends State<AddressDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentSelectedZone;
  String _currentSelectedCity;
  bool _submitted = false;

  final TextEditingController titleFieldController = TextEditingController();

  final TextEditingController receiverFieldController = TextEditingController();

  final TextEditingController addressFieldController = TextEditingController();

  final TextEditingController cityFieldController = TextEditingController();

  final TextEditingController districtFieldController = TextEditingController();

  final TextEditingController stateFieldController = TextEditingController();

  final TextEditingController landmarkFieldController = TextEditingController();

  final TextEditingController pincodeFieldController = TextEditingController();

  final TextEditingController phoneFieldController = TextEditingController();

  @override
  void dispose() {
    titleFieldController.dispose();
    receiverFieldController.dispose();
    addressFieldController.dispose();
    cityFieldController.dispose();
    stateFieldController.dispose();
    districtFieldController.dispose();
    landmarkFieldController.dispose();
    pincodeFieldController.dispose();
    phoneFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildTextField(titleFieldController, "Title", "Enter a title for address"),
          buildTextField(receiverFieldController, "Receiver Name", "Enter Receiver's Full Name"),
          buildSelectField("Zone", "Select Zone",
              fieldValueIsNull: _currentSelectedZone == null,
              isEmpty: _currentSelectedZone == '',
              dropdownButton: buildDropdownButtonForZone,
              validator: zoneValidator),
          buildSelectField("City", "Select City",
              fieldValueIsNull: _currentSelectedCity == null,
              isEmpty: _currentSelectedCity == '',
              dropdownButton: buildDropdownButtonForCity,
              validator: cityValidator),
          buildTextField(addressFieldController, "Address Line", "Enter Address Line"),
          buildTextField(landmarkFieldController, "Landmark", "Enter Landmarks near Location"),
          buildTextField(phoneFieldController, "Phone Number", "Enter Phone Number", inputType: TextInputType.number),
          DefaultButton(
            text: "Save Address",
            press: widget.addressToEdit == null ? saveNewAddressButtonCallback : saveEditedAddressButtonCallback,
          ),
        ],
      ),
    );
    if (widget.addressToEdit != null) {
      titleFieldController.text = widget.addressToEdit.title;
      receiverFieldController.text = widget.addressToEdit.receiver;
      addressFieldController.text = widget.addressToEdit.address;
      landmarkFieldController.text = widget.addressToEdit.landmark;
      phoneFieldController.text = widget.addressToEdit.phone;
      setState(() {
        _currentSelectedCity = widget.addressToEdit.city;
        _currentSelectedZone = widget.addressToEdit.zone;
      });
    }
    return form;
  }

  DropdownButton buildDropdownButtonForZone(FormFieldState<String> state) {
    return DropdownButton<String>(
      hint: Text('Please choose a Zone'),
      style: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      value: _currentSelectedZone,
      isDense: true,
      onChanged: (String newValue) {
        setState(() {
          _currentSelectedZone = newValue;
          _currentSelectedCity = null;
          state.didChange(newValue);
        });
      },
      items: nepalZonesAndDistricts.keys.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButton buildDropdownButtonForCity(FormFieldState<String> state) {
    List<String> cities = _currentSelectedZone == null ? [] : nepalZonesAndDistricts[_currentSelectedZone];
    return DropdownButton<String>(
      hint: Text('Please choose your City'),
      style: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      value: _currentSelectedCity,
      isDense: true,
      onChanged: (String newValue) {
        setState(() {
          _currentSelectedCity = newValue;
          state.didChange(newValue);
        });
      },
      items: cities.isEmpty
          ? []
          : cities.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleFieldController,
      keyboardType: TextInputType.name,
      maxLength: 8,
      decoration: InputDecoration(
        hintText: "Enter a title for address",
        labelText: "Title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildReceiverField() {
    return TextFormField(
      controller: receiverFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Full Name of Receiver",
        labelText: "Receiver Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (receiverFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine1Field() {
    return TextFormField(
      controller: addressFieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter Address Line No. 1",
        labelText: "Address Line 1",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (addressFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCityField() {
    return TextFormField(
      controller: cityFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter City",
        labelText: "City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (cityFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildTextField(
    TextEditingController fieldController,
    String labelText,
    String hintText, {
    TextInputType inputType,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: fieldController,
          keyboardType: inputType ?? TextInputType.name,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 0.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding: EdgeInsets.all(10),
            hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
          ),
          validator: (value) {
            if (fieldController.text.isEmpty) {
              return FIELD_REQUIRED_MSG;
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
      ],
    );
  }

  String zoneValidator(value) {
    // if (_currentSelectedZone.isEmpty) {
    return FIELD_REQUIRED_MSG;
    // }
    return null;
  }

  String cityValidator(value) {
    if (_currentSelectedCity.isEmpty) {
      return FIELD_REQUIRED_MSG;
    }
    return null;
  }

  Widget buildSelectField(
    String labelText,
    String hintText, {
    bool fieldValueIsNull,
    bool isEmpty,
    DropdownButton dropdownButton(FormFieldState<String> state),
    Function validator,
  }) {
    return Column(
      children: [
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                errorText: _submitted && fieldValueIsNull ? "This field is required." : null,
                hintText: hintText,
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 0.1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding: EdgeInsets.all(10),
                hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
              ),
              isEmpty: isEmpty,
              child: DropdownButtonHideUnderline(
                child: dropdownButton(state),
              ),
            );
          },
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
      ],
    );
  }

  Widget buildZonesField() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelStyle: textStyle,
            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            hintText: 'Select Zone',
            // hintText: "Enter City",
            labelText: "Zone",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 0.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding: EdgeInsets.all(10),
            hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
          ),
          isEmpty: _currentSelectedZone == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedZone,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _currentSelectedZone = newValue;
                  state.didChange(newValue);
                });
              },
              items: nepalZonesAndDistricts.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value.toUpperCase(),
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildDistrictField() {
    return TextFormField(
      controller: districtFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter District",
        labelText: "District",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (districtFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return TextFormField(
      controller: stateFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter State",
        labelText: "State",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (stateFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPincodeField() {
    return TextFormField(
      controller: pincodeFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter PINCODE",
        labelText: "PINCODE",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (pincodeFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (!isNumeric(pincodeFieldController.text)) {
          return "Only digits field";
        } else if (pincodeFieldController.text.length != 6) {
          return "PINCODE must be of 6 Digits only";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLandmarkField() {
    return TextFormField(
      controller: landmarkFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Landmark",
        labelText: "Landmark",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (landmarkFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Phone Number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(10),
        hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
      ),
      validator: (value) {
        if (phoneFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (phoneFieldController.text.length != 10) {
          return "Only 10 Digits";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveNewAddressButtonCallback() async {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress = generateAddressObject();
      bool status = false;
      String snackbarMessage;
      try {
        status = await UserDatabaseHelper().addAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address saved successfully";
        } else {
          throw "Coundn't save the address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Future<void> saveEditedAddressButtonCallback() async {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress = generateAddressObject(id: widget.addressToEdit.id);

      bool status = false;
      String snackbarMessage;
      try {
        status = await UserDatabaseHelper().updateAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address updated successfully";
        } else {
          throw "Couldn't update address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Address generateAddressObject({String id}) {
    return Address(
      id: id,
      title: titleFieldController.text,
      receiver: receiverFieldController.text,
      address: addressFieldController.text,
      city: _currentSelectedCity,
      zone: _currentSelectedZone,
      landmark: landmarkFieldController.text,
      phone: phoneFieldController.text,
      // district: districtFieldController.text,
      // state: stateFieldController.text,
    );
  }
}
