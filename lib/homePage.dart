import 'package:weatherApp/exception/exception.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:weatherApp/api/mainRequest.dart';
import 'package:weatherApp/models/weatherModel.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityController = new TextEditingController();
  MainRequest _mainRequest = MainRequest();
  GetWeatherData getWeatherData = GetWeatherData();
  Future<GetWeatherData> _future;
  bool _isCountry = false;

  sendRequest() async {
    await _mainRequest.sendCityName(cityController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cityController.addListener(() {
      return cityController.text;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: FutureBuilder<GetWeatherData>(
                future: _mainRequest.sendCityName(cityController.text),
                builder: (context, AsyncSnapshot<GetWeatherData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('none');
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                      // TODO: Handle this case.
                      return Text('');
                      break;
                    case ConnectionState.done:
                      // TODO: Handle this case.
                      if (snapshot.hasError) {
                        return Text(snapshot.error);
                      } else if (cityController.text.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // the container for the search bar starts here
                                Expanded(
                                  child: Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0)),
                                        color: Colors.grey[100]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                      child: TextFormField(
                                        controller: cityController,
                                        decoration: InputDecoration(
                                            hintText: 'Enter city name',
                                            suffixIcon: cityController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 18.0,
                                                    ),
                                                    onPressed: () {
                                                      cityController.clear();
                                                    })
                                                : Container(
                                                    height: 0.0, width: 0.0),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                                // container for the search bar ends here

                                //start of send button
                                Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.send, color: Colors.white70,),
                                        onPressed: () {
                                          setState(() {
                                            sendRequest();
                                          });
                                        })),
                                // end of send icon
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              children: [
                                snapshot.data == null &&
                                        cityController.text.isEmpty
                                    ? Text('Nothing yet')
                                    : Text(
                                        '${snapshot.data.name},',
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                snapshot.data == null &&
                                        cityController.text.isEmpty
                                    ? Text('')
                                    : Text(
                                        snapshot.data.sys.country,
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                              ],
                            ),

                            // name ends here
                            SizedBox(
                              height: 30.0,
                            ),

                            Container(
                              height: MediaQuery.of(context).size.height / 1.7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(colors: [
                                    Colors.lightBlueAccent,
                                    Colors.lightBlueAccent[200]
                                  ])),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    snapshot.data == null
                                        ? Container()
                                        : Container(
                                            height: 100.0,
                                            width: 100.0,
                                            child: Image.network(
                                                'http://openweathermap.org/img/wn/${snapshot.data.weather[0].icon}@2x.png'),
                                          ),
                                    snapshot.data == null &&
                                            cityController.text.isEmpty
                                        ? Text('')
                                        : Text(
                                            snapshot
                                                .data.weather[0].description,
                                            style: TextStyle(
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                    SizedBox(height: 8.0),
                                    snapshot.data == null &&
                                            cityController.text.isEmpty
                                        ? Text('')
                                        : Text(
                                            snapshot.data.weather[0].main,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.blue[900],
                                              letterSpacing: 0.5,
                                            ),
                                          ),

                                    //main temp degree
                                    SizedBox(
                                      height: 20.0,
                                    ),
// \u2103
                                    snapshot.data == null &&
                                            cityController.text.isEmpty
                                        ? Text('')
                                        : Text(
                                            "${snapshot.data.main.temp.ceil() - 273.15.ceil()}\u2103",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 90.0,
                                                fontWeight: FontWeight.w600)),

                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Divider(
                                      color: Colors.white,
                                      height: 5.0,
                                    ),

                                    //other properties
                                    SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                WeatherIcons.wind,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "WIND",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  snapshot.data == null &&
                                                          cityController
                                                              .text.isEmpty
                                                      ? Container()
                                                      : Text(
                                                          snapshot.data.wind
                                                                  .speed
                                                                  .toString() +
                                                              "kmhr",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      26.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          //humidity
                                          Row(
                                            children: [
                                              Icon(
                                                WeatherIcons.humidity,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "HUMIDITY",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  snapshot.data == null &&
                                                          cityController
                                                              .text.isEmpty
                                                      ? Container()
                                                      : Text(
                                                          snapshot.data.main
                                                                  .humidity
                                                                  .toString() +
                                                              "g.kg",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      26.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          )
                                          //humidty ends
                                        ],
                                      ),
                                    ),

                                    //second section starts here
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Divider(
                                      color: Colors.white,
                                      height: 5.0,
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    // other properties

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                WeatherIcons.barometer,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "PRESSURE",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  snapshot.data == null &&
                                                          cityController
                                                              .text.isEmpty
                                                      ? Container()
                                                      : Text(
                                                          snapshot.data.main
                                                                  .pressure
                                                                  .toString() +
                                                              "mbar",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      26.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          //Feels-like
                                          Row(
                                            children: [
                                              Icon(
                                                WeatherIcons.thermometer,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "FEELS-LIKE",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  snapshot.data == null &&
                                                          cityController
                                                              .text.isEmpty
                                                      ? Container()
                                                      : Text(
                                                          " ${snapshot.data.main.feelsLike.ceil() - 273 - 15.ceil()}\u2103",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      26.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          )
                                          //humidty ends
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OtherStuffs(
                                    visibility: snapshot.data.visibility,
                                    information: "VISIBILITY(m)",
                                    data: Icons.remove_red_eye,
                                  ),
                                  OtherStuffs(
                                    visibility: snapshot.data.wind.deg,
                                    information: "WIND DEGREE",
                                    data: WeatherIcons.wind_beaufort_0,
                                  ),
                                  OtherStuffs(
                                    visibility: snapshot.data.timezone,
                                    information: "TIMEZONE(est)",
                                    data: Icons.av_timer,
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }else if(snapshot.data != null && snapshot.data.name != cityController.text){
                        return Container();
                      }
                      
                       else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // the container for the search bar starts here
                            Expanded(
                              child: Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    color: Colors.grey[100]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: TextFormField(
                                    controller: cityController,
                                    decoration: InputDecoration(
                                        hintText: 'Enter city name',
                                        suffixIcon:
                                            cityController.text.isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 18.0,
                                                    ),
                                                    onPressed: () {
                                                      cityController.clear();
                                                    })
                                                : Container(
                                                    height: 0.0,
                                                    width: 0.0,
                                                  ),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                            // container for the search bar ends here

                            //start of send button
                            Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                ),
                                child: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () async{
                                      try{
                                        setState(() {
                                        sendRequest();
                                      });
                                      }catch (e){
                                        throw e; 
                                      }
                                    })),
                            // end of send icon
                          ],
                        );
                      }
                      break;
                  }
                },
              ),
            ),
          ),
        ));
  }
}

class OtherStuffs extends StatelessWidget {
  final String information;
  final int visibility;
  final IconData data;
  const OtherStuffs({
    this.information,
    this.visibility,
    this.data,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 120.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.lightBlueAccent,
            Colors.lightBlueAccent[100],
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(data, color: Colors.white60),
            Text(
              information,
              style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              visibility.toString(),
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
