import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<GodInfo> ListGodInfo;
NumberFormat twonumber = new NumberFormat("00");
NumberFormat fournumber = new NumberFormat("0000");

void main() {
  LoadGodList().then((value) => {
        ListGodInfo = value,
        runApp(MaterialApp(
          title: '',
          home: MyHomePage(),
        ))
      });
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final controller = PageController(
  initialPage: 1000,
);
final controller1 = PageController(
  initialPage: 1000,
);

extension LoopList<T> on List {
  T loop(int index) => this[index % this.length];
}

const List<Color> _colors = [Colors.blue, Colors.green, Colors.red];

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;

  static var txtStyle = new TextStyle(color: Colors.black87, fontSize: 11);
  static var txtStyle2 = new TextStyle(
      color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13);
  static var txtStyle3 = new TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13);

  static var padding = new EdgeInsets.only(bottom: 5);

  DateFormat format;
  DateFormat formatmonthvn;
  static DateTime DayStart;
  static DateTime now = DateTime.now();

  static DateTime currentDate = now;
  // static GodInfo currentGodInfo;
  GodInfo zeroGodInfo = new GodInfo();
  static DateTime currentmonthyear = now;
  int currentCalendarPage = 1000;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    format = new DateFormat.EEEE('en');
    formatmonthvn = new DateFormat.MMMM('vi');
    DayStart = DateTime.now()
        .subtract(Duration(days: getIndexDayOfWeek(format.format(now)))); //
    print(DateTime.now().toString() + DayStart.toString());
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    PageView pageView = PageView.builder(
        controller: controller1,
        scrollDirection: Axis.horizontal,
        onPageChanged: (int page) {
          print(page.toString());
          setState(() {
            currentDate = now.add(Duration(days: page - 1000));
            currentDate;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          // print(int.parse(twonumber.format(currentDate.month).toString() +
          //     twonumber.format(currentDate.day).toString()));
          GodInfo currentGodInfo = ListGodInfo.firstWhere(
              (element) =>
                  element.goddate ==
                  int.parse(twonumber.format(currentDate.month).toString() +
                      twonumber.format(currentDate.day).toString()),
              orElse: () => new GodInfo());
          return Container(
            // color: _colors.loop(index),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.125),
                width: width * 0.5,
                height: width * 0.5,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: currentGodInfo.godimage == null
                        ? AssetImage("assets/thaptugia.jpg")
                        : NetworkImage(
                            ipserver + 'image/' + currentGodInfo.godimage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                // color: Colors.orange,
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  Text(() {
                    if (currentGodInfo.goddate == null) {
                      return "";
                    } else {
                      var number = fournumber
                          .format(currentGodInfo.goddate)
                          .toString()
                          .split('');
                      return number[0] +
                          number[1] +
                          "/" +
                          number[2] +
                          number[3];
                    }
                  }(),
                      style: new TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        currentGodInfo.godname == null
                            ? ""
                            : currentGodInfo.godname,
                        style: new TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Text(
                      currentGodInfo.biographeshort == null
                          ? ""
                          : currentGodInfo.biographeshort,
                      style: new TextStyle(color: Colors.black87)),
                ]),
              ),
            ]),
            // Image.network(ipserver+'image/'+currentGodInfo.godimage),
          );
        });
    PageView calendarWeek = PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        onPageChanged: (int page) {
          setState(() {
            currentCalendarPage = page;
            currentmonthyear;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          if (DayStart.add(Duration(days: ((index - 1000) * 7) + 0)).month !=
                  currentmonthyear.month &&
              DayStart.add(Duration(days: ((index - 1000) * 7) + 6)).month !=
                  currentmonthyear.month) {
            currentmonthyear = new DateTime(
                currentmonthyear.year,
                DayStart.add(Duration(days: ((index - 1000) * 7) + 0)).month,
                currentmonthyear.day);
            // print(currentmonthyear);
            // setState(() {
            // });
          }

          Container1(DateTime date1) {
            // print("hom nay "+ currentDate.toString()+date1.toString());
            return InkWell(onTap: () {
              print(new DateTime(date1.year, date1.month, date1.day)
                      .toString() +
                  "_" +
                  new DateTime(
                          currentDate.year, currentDate.month, currentDate.day)
                      .toString()
                      .toString() +
                  "_" +
                  new DateTime(date1.year, date1.month, date1.day)
                      .difference(new DateTime(
                          currentDate.year, currentDate.month, currentDate.day))
                      .inDays
                      .toString());
              var pagetojump = 1000 +
                  new DateTime(date1.year, date1.month, date1.day)
                      .difference(new DateTime(now.year, now.month, now.day))
                      .inDays;
              controller1.jumpToPage(pagetojump);
              controller1.animateToPage(pagetojump);
            }, child: () {
              if (currentDate.year == date1.year &&
                  currentDate.month == date1.month &&
                  currentDate.day == date1.day) {
                return Container(
                  padding: EdgeInsets.all(7.5),
                  // alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: Text(
                    date1.day.toString(),
                    style: txtStyle3,
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(7.5),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.black,
                  ),
                  child: Text(
                    date1.day.toString(),
                    style: txtStyle2,
                  ),
                );
              }
            }());
          }

          return Container(
            // width: 200,
            // height:50,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 75,
                  // color: Colors.red,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 2",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 0))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.black,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 3",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 1))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.red,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 4",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 2))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.black,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 5",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 3))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.red,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 6",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 4))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.black,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "Thứ 7",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 5))),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  // color: Colors.red,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: padding,
                          child: Text(
                            "CN",
                            style: txtStyle,
                          ),
                        ),
                        Container1(DayStart.add(
                            Duration(days: ((index - 1000) * 7) + 6))),
                      ]),
                ),
              ),
            ]),
          );
        });

    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.9), BlendMode.dstATop),
              image: AssetImage("assets/wallpaperflare.com_wallpaper.jpg"),
              // NetworkImage(
              //     "https://tophinhnen.com/wp-content/uploads/2018/03/chua-jesus-1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          //width:double.infinity,
          //height: 500,
          // color: Colors.red,
          child: Column(
            children: [
              Stack(children: [
                Container(
                    child: Column(children: [
                  Container(
                    //color: Colors.white.withOpacity(0.2),
                    height: height * 0.65,
                    width: width * 1,
                    child: pageView,
                  ),
                  Container(
                    height: height * 0.35,
                    width: width * 1,
                    // color: Colors.redAccent,
                    child: Container(
                      // decoration: new BoxDecoration(
                      //   shape: BoxShape.rectangle,
                      //   color: Colors.grey.withOpacity(0.3),
                      // ),
                      child: Column(children: [
                        Container(
                            height: 40,
                            width: double.infinity,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller
                                          .jumpToPage((currentCalendarPage-1));
                                      controller.animateToPage((currentCalendarPage-1));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      height: double.infinity,
                                      width: 40,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black87,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatmonthvn.format(currentmonthyear) +
                                        ", " +
                                        currentmonthyear.year.toString(),
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.jumpToPage(
                                          (currentCalendarPage + 1));
                                      controller.animateToPage(
                                          (currentCalendarPage + 1));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 20),
                                      width: 40,
                                      height: double.infinity,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black54,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ])),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: calendarWeek,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //   ]
                          // ),
                        ),
                      ]),
                    ),
                  ),
                ])),
                Container(
                  height: height * 0.15,
                  width: width * 1,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            // color: Colors.black,
                            child: Icon(
                          Icons.search,
                          color: Colors.black87,
                        )),
                        // Container(
                        //     child: Text(
                        //   "Thứ 7, ngày 14 tháng 5",
                        //   style: TextStyle(color: Colors.white),
                        // )),
                      ]),
                ),
              ]),
            ],
          )),
    );
  }
}

int getIndexDayOfWeek(String NameDayOfWeek) {
  int result;
  switch (NameDayOfWeek) {
    case "MonDay":
      result = 0;
      break;
    case "Tuesday":
      result = 1;
      break;
    case "Wednesday":
      result = 2;
      break;
    case "Thursday":
      result = 3;
      break;
    case "Friday":
      result = 4;
      break;
    case "Saturday":
      result = 5;
      break;
    case "Sunday":
      result = 6;
      break;
  }
  print(result);
  return result;
}

class DayOfWeek {
  final String NameDayOfWeek;
  final int Day;
  DayOfWeek(this.NameDayOfWeek, this.Day);
}

class GodInfo {
  int id;
  String godname;
  int goddate;
  String biographeshort;
  String godimage;
  GodInfo(
      {this.id,
      this.godname,
      this.goddate,
      this.biographeshort,
      this.godimage});
  factory GodInfo.FromData(Map<String, dynamic> data) {
    return GodInfo(
        id: data['id'] as int,
        godname: data['godname'] as String,
        goddate: int.parse(data['goddate'] as String),
        biographeshort: data['biographeshort'] as String,
        godimage: data['godimage'] as String);
  }
}

List<GodInfo> parseGodList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<GodInfo>((json) => GodInfo.FromData(json)).toList();
}

String ipserver = "http://54.211.5.165:84/";

Future<List<GodInfo>> LoadGodList() async {
  final response = await http.post(ipserver + "godlist");

  if (response.statusCode == 200) {
    print(response.body);
    return parseGodList(response.body);
  } else {
    throw Exception('can not load');
  }
}
