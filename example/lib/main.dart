import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Phone Field Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: PhoneField(
                  codeSpace: 1,
                  flagSpace: 10,
                  languageCode: "ar",
                  showDropdownIcon: false,
                  initialCountryCode: 'EG',
                  controller: TextEditingController(),
                  onChanged: (phone) => print(phone.completeNumber),
                  onTapOutside: (p0) => FocusManager.instance.primaryFocus?.unfocus(),
                  onCountryChanged: (country) => print('Country changed to: ${country.name}'),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
