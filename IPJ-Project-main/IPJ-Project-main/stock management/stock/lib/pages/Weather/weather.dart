import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String api = '8ff50d1b9ba1ce60055d1061961be8a1';
  int temperature = 0;
  late String location = 'Free State';
  late int id = 1018725;
  String weather = '';
  String abbrevasition = '';
  String errorMassage = '';
  late double lat = 0;
  late double lon = 0;
  List<String> abbreviationForecast = List.filled(7, '');
  List<int> minTemperatureForecast = List.filled(7, 0);
  List<int> maxTemperatureForecast = List.filled(7, 0);

//

  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    // fetchSearch('Free State');
    fetchLocation();
    fetchLocationDay();
  }

  @override
  void dispose() {
    usernameController.dispose();

    super.dispose();
  }

  Future<void> fetchSearch(String input) async {
    try {
      final searchResult = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${input}&appid=3cb9b573cc06678d9a74fae11f73f009'));
      var result = json.decode(searchResult.body);

      setState(() {
        location = result['name'];
        id = result['id'];

        // lat = result['coord']['lat'];

        // lon = result['coord']['lon'];

        errorMassage = '';
      });
    } catch (error) {
      setState(() {
        errorMassage = 'Sorry,Try Another city';
      });
    }
  }

  Future<void> fetchLocation() async {
    var locationResult = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?id=${id}&appid=3cb9b573cc06678d9a74fae11f73f009'));
    var result = json.decode(locationResult.body);
    var data = result['weather'][0];
    var data1 = result['main'];
    //description
    setState(() {
      temperature = data1['temp'].round();
      lat = result['coord']['lat'];

      lon = result['coord']['lon'];

      print('${lon} ::::  ${lat}');
      weather = data['main'].replaceAll('', '').toLowerCase();
      abbrevasition = data['icon'];
    });
  }

  // void fetchLocationDay() async {
  //   var today = new DateTime.now();
  //   for (var i = 0; i < 4; i++) {
  //     var locationDayResult = await http.get(locationApiUrl +
  //         id.toString() +
  //         '/' +
  //         new DateFormat('y/M/d')
  //             .format(today.add(new Duration(days: i + 1)))
  //             .toString());
  //     var result = json.decode(locationDayResult.body);
  //     var data = result[0];

  //     setState(() {
  //       minTemperatureForecast[i] = data["min_temp"].round();
  //       maxTemperatureForecast[i] = data["max_temp"].round();
  //       abbreviationForecast[i] = data["weather_state_abbr"];
  //     });
  //   }
  // }

  Future<void> fetchLocationDay() async {
    var today = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=3cb9b573cc06678d9a74fae11f73f009'));
    //'https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=3cb9b573cc06678d9a74fae11f73f009'));
    var result1 = json.decode(today.body);

    for (int i = 0; i < 7; i++) {
      setState(() {
        abbreviationForecast[i] = result1['list'][i]["weather"][0]['icon'];
        maxTemperatureForecast[i] =
            result1['list'][i]['main']['temp_max'].round();
        minTemperatureForecast[i] =
            result1['list'][i]['main']['temp_min'].round();
        // print(result1['list'][2]["weather"][0]['icon']);
      });
    }
  }

  void onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
    await fetchLocationDay();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/${weather}.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: lon == 0 || lat == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Image.network(
                            'http://openweathermap.org/img/wn/${abbrevasition}@2x.png',
                            width: 100,
                          ),
                        ),
                        Center(
                          child: Text(
                            temperature.toString() + '°C',
                            style: TextStyle(color: Colors.blue, fontSize: 60),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            location.toString(),
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (var i = 0; i < 7; i++)
                                forecastElement(
                                    i + 1,
                                    abbreviationForecast[i],
                                    minTemperatureForecast[i],
                                    maxTemperatureForecast[i]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: 300,
                          child: TextField(
                            controller: usernameController,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            decoration: InputDecoration(
                              hintText: 'Search another location...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  onTextFieldSubmitted(usernameController.text);
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          errorMassage,
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

Widget forecastElement(
    daysFromNow, abbrevasition, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(205, 212, 228, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              new DateFormat.E().format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              new DateFormat.MMMd().format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Image.network(
                'http://openweathermap.org/img/wn/${abbrevasition}@2x.png',
                width: 50,
              ),
            ),
            Text(
              'High: ' + maxTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.purple, fontSize: 20.0),
            ),
            Text(
              'Low: ' + minTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
    ),
  );
}
