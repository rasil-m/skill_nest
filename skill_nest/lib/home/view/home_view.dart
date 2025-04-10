// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:skill_nest/components/subject_card_cmp.dart';
import 'package:skill_nest/components/subject_tile_cmp.dart';
import 'package:skill_nest/home/view_model/home_view_model.dart';
import 'package:skill_nest/main.dart';
import 'package:skill_nest/modules/view/module_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  _buildTitle({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            color: AppTheme.secondaryBlack,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        surfaceTintColor: AppTheme.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Icon(Icons.sort),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Skill Nest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.notifications_none, color: Colors.black87),
                onPressed: () {},
              ),
              const Positioned(
                right: 11,
                top: 11,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          color: AppTheme.secondaryColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(
                title: "Featured for You",
                description: "Curated to help you grow.",
              ),
              SizedBox(height: 12),
              vm.homeLoader
                  ? Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: AppTheme.blue,
                        ),
                      ),
                    )
                  : Container(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.subjects.length - 3,
                        itemBuilder: (context, index) {
                          var subject = vm.subjects[index];
                          return InkWell(
                            onTap: () {
                              vm.setSelectedSubject(subject);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModuleView(),
                                ),
                              );
                            },
                            child: SubjectCard(
                              subject: subject,
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 24),
              _buildTitle(
                title: "All Courses",
                description: "Explore and get started.",
              ),
              SizedBox(height: 15),
              vm.homeLoader
                  ? Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: AppTheme.blue,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: vm.subjects.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var subject = vm.subjects[index];
                        return InkWell(
                          onTap: () {
                            vm.setSelectedSubject(subject);
                            vm.fetchModules();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModuleView(),
                                ));
                          },
                          child: SubjectTileCmp(
                            subject: subject,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
