import 'dart:io';

import 'package:flutter/material.dart';


class ProyectoWidget extends StatelessWidget {
  late final String title;
  final int count;

  ProyectoWidget({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(3,0,3,3),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red[700],
        // borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: Text( count== 0 ? "Sin reportes" : count==1 ? "$count reporte" : "$count reportes",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                // height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class TaskCardWidget extends StatelessWidget {
  final String title;
  late final String date;
  late final int count;

  TaskCardWidget({required this.title, required this.date, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(3,0,3,3),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red[700],
        // borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.0,
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: Text( count== 0 ? "Sin ítemes" : count==1 ? "$count item" : "$count ítemes",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                // height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ItemWidget extends StatelessWidget {
  final int? id;
  final String? desc;
  // final bool isDone;

  // TodoWidget({this.desc, @required this.isDone});
  ItemWidget({this.id, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red[700],
        // borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '$id - ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    // color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                    color: Colors.grey[400],
                    fontSize: 16.0,
                    // fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                    fontWeight:FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  desc ?? "(Unnamed Item)",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    // color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                    color: Colors.grey[400],
                    fontSize: 16.0,
                    // fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                    fontWeight:FontWeight.bold,
                  ),
                ),
              ),
            ],
    ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.0,
            ),
          ),
        ],
      ),
    );
  }
}


class ItemSearchResultWidget extends StatelessWidget {
  final int? id;
  final String? desc;
  final String? reportTitle;
  final String? reportDate;

  const ItemSearchResultWidget({
    super.key,
    this.id,
    this.desc,
    this.reportTitle,
    this.reportDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red[700], // same as ItemWidget
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // first row: id + description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '$id - ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  desc ?? "(Unnamed Item)",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // second row: report title + date
          if (reportTitle != null || reportDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 48.0),
              // indent so it aligns under description
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      reportTitle ?? "(No Report Title)",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 13.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  if (reportDate != null)
                    Text(
                      reportDate!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
        ],
      ),
    );
  }
}


class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class PhotoWidget extends StatelessWidget {
  // late final int id;
  String? photo;
  // final bool isDone;

  // PhotoWidget({this.id, required this.photo});
  PhotoWidget({this.photo});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        // borderRadius: BorderRadius.circular(20.0),
      ),
      child: GridTile(
        child: Image.file(File(photo!)),
        // child: Utility.imageFromBase64String(Utility.base64String(File(photo).readAsBytesSync())),
        // child: Utility.imageFromBase64String(photo),
      ),
    );
  }
}