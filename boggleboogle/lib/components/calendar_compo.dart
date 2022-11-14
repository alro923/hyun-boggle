//import 'dart:html';
//
import 'dart:collection';
import 'dart:async';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarCom extends StatefulWidget {
  final mail;
  const CalendarCom({Key? key, required this.mail}) : super(key: key);
  @override
  State<CalendarCom> createState() => _CalendarComState();
}

class _CalendarComState extends State<CalendarCom> {
  String? user_id;

  _getdata() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      user_id = user?.email;
      print(user_id);
    });
  }

  _listdate() async {
    List<String> datelist = [];
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.mail)
        .collection("Dates");
    userRef.get().then((value) {
      value.docs.forEach((element) {
        print(element.id);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _listdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? day_return;
    String? is_done;

    //보글이 부글이 데이터
    //Future<String>

    Future<String?> _readdatedata() async {
      final userRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.mail)
          .collection("Dates")
          .doc(day_return);
      await userRef.get().then((DocumentSnapshot doc) {
        is_done = doc['isDone'];
        print("출력");
        print(is_done);
      });
    }

    String? readdate() {
      final userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.mail)
          .collection("Dates")
          .doc(day_return);
      userRef.get().then((DocumentSnapshot doc) {
        is_done = doc['isDone'];
        //print(is_done);
        return is_done;
      });
    }

    void searchdoc() {}

    _delay() async {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    Widget _boggle() {
      return Container(
        //margin: EdgeInsets.all(10),
        child: Image.asset(
            '/Users/gyul/github_Sourcetree/new_booggle/bogleboogle/boggleboogle/lib/boggle-cutout.png'),
        width: 40,
        height: 40,
      );
    }

    Widget _boogle() {
      return Container(
        //margin: EdgeInsets.all(10),
        child: Image.asset(
            '/Users/gyul/github_Sourcetree/new_booggle/bogleboogle/boggleboogle/assets/images/boogle.png'),
        //child: Icon(Icons.favorite_border_outlined, color: Colors.red),
        width: 40,
        height: 40,
      );
    }

    String day_get(String datatr) {
      return datatr;
    }

    return TableCalendar(
      firstDay: DateTime.utc(2015, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: DateTime.now(),
      locale: 'ko-KR',
      //daysOfWeekHeight: 10,
      rowHeight: 70,
      /*
      eventLoader: (day) {
        //final dateStr = DateFormat('yyyy-MM-dd').format(day);
        //day_return = day_get(dateStr);
        /*String? future = readdate();
        //print(future);
        if (future == "0") {
          print("read 실행");
          return ['boggle', 'boogle'];
        } else if (future == "1") {
          return ['hi'];
        }
        return [];*/
      },*/
      //보글이 이미지 넣는 것 (조건 맞춰야함)

      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          //print(events.length);
          final dateStr = DateFormat('yyyy-MM-dd').format(date);
          day_return = day_get(dateStr);
          //String? ref = readdate();
          //print(ref);
          String? ref;
          _readdatedata()
              .whenComplete(() => ref = is_done)
              .whenComplete(() => CalendarBuilders);

          if (ref == "0") {
            return Align(
              alignment: Alignment(0.0, 1.7),
              child: _boggle(),
            );
          } else if (ref == "1") {
            return Align(
              alignment: Alignment(0.0, 1.7),
              child: _boogle(),
            );
          }
        },
        dowBuilder: (context, day) {
          //캘린더 요일 영어에서 한국어로 변경 및 색 변경
          switch (day.weekday) {
            case 1:
              return Center(
                child: Text('월'),
              );
            case 2:
              return Center(
                child: Text('화'),
              );
            case 3:
              return Center(
                child: Text('수'),
              );
            case 4:
              return Center(
                child: Text('목'),
              );
            case 5:
              return Center(
                child: Text('금'),
              );
            case 6:
              return Center(
                child: Text(
                  '토',
                  style: TextStyle(color: Colors.blue),
                ),
              );
            case 7:
              return Center(
                child: Text(
                  '일',
                  style: TextStyle(color: Colors.red),
                ),
              );
          }
        },
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(
          color: Color.fromARGB(255, 141, 166, 140),
        ),
        weekendTextStyle: TextStyle(color: Color.fromARGB(255, 158, 158, 158)),
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(0, 160, 244, 86),
          shape: BoxShape.rectangle,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 84, 14),
          decoration: TextDecoration.underline,
          decorationColor: Color.fromARGB(245, 23, 58, 21),
          //backgroundColor: Color.fromARGB(255, 141, 166, 140)
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
    //backgroundColor: Color.fromARGB(255, 171, 199, 100),
  }
}

class Event {
  String date; // 날짜
  String isDone; //성공 여부
  Event(this.date, this.isDone);

  @override
  String toString() => date;
}