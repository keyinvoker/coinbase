import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

void main() => runApp(const MyApp());

class CryptoScreen extends StatelessWidget {
  const CryptoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokekCrypto',
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: const Text('TokekCoin'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[800],
        ),
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen[600],
              ),
              child: const Text('Tokek Drawer'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                //
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                //
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 3'),
              onTap: () {
                //
                Navigator.pop(context);
              },
            ),
          ]),
        ),
        body: Column(
          children: [
            _SearchField(),
            SizedBox(height: 10.0),
            SizedBox(height: 30.0, child: _Filters()),
            SizedBox(height: 10.0),
            Expanded(
                child: Assets(
              name: '',
              unit: '',
              value: '',
            )),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 8.0,
            ),
            const Icon(
              Icons.search,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search assets',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(width: 16.0),
        _Filter(name: 'Crypto', isActive: true),
        _Filter(name: 'Fiat'),
        _Filter(name: 'Commodity'),
      ],
    );
  }
}

class _Filter extends StatelessWidget {
  const _Filter({
    Key? key,
    required this.name,
    this.isActive = false,
  }) : super(key: key);

  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: isActive
              ? Colors.lightGreenAccent
              : Colors.white.withOpacity(0.8),
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: isActive
                ? Colors.lightGreenAccent
                : Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
    );
  }
}

class Assets extends StatelessWidget {
  final String name;
  final String unit;
  final String value;

  Assets({
    Key? key,
    required this.name,
    required this.unit,
    required this.value,
  }) : super(key: key);

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      name: json['name'],
      unit: json['unit'],
      value: json['value'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 80.0,
        color: Colors.black.withOpacity(0.4),
        margin: const EdgeInsets.only(left: 15, right: 15),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                )
              ],
            )
          ],
        ));
  }
}

// fetching data from API:
Future<List<Assets>> fetchAsset() async {
  var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((assets) => Assets.fromJson(assets)).toList();
  } else {
    throw Exception('Data fetching error!');
  }
}
