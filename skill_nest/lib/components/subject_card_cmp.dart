// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:skill_nest/home/model/subject_model.dart';
import 'package:skill_nest/modules/view/module_view.dart';

class SubjectCard extends StatelessWidget {
  Subject subject;
  SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.secondaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              subject.image,
              width: 180,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            subject.title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                "Complete now",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: AppTheme.secondaryBlack,
                ),
              ),
              Spacer(),
              Icon(
                Icons.play_circle,
                size: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}
