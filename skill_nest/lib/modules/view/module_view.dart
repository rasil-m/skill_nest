// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:skill_nest/components/module_tile_cmp.dart';
import 'package:skill_nest/components/subject_tile_cmp.dart';
import 'package:skill_nest/home/view_model/home_view_model.dart';
import 'package:skill_nest/video/view/video_list.dart';

class ModuleView extends StatelessWidget {
  const ModuleView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewModel vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          Image.network(
            vm.selectedSubject.image,
            width: MediaQuery.of(context).size.width,
            height: 300,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 260),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.selectedSubject.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    vm.selectedSubject.description,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins",
                      color: AppTheme.secondaryBlack,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  vm.moduleLoader
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
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.47,
                          child: ListView.builder(
                            itemCount: vm.modules.length,
                            itemBuilder: (context, index) {
                              var module = vm.modules[index];
                              return InkWell(
                                onTap: () {
                                  vm.setselectedModule(module);
                                  vm.fetchVideos();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoList(),
                                    ),
                                  );
                                },
                                child: ModuleTileCmp(
                                  modules: module,
                                ),
                              );
                            },
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
