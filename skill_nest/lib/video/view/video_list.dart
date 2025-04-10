// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:skill_nest/components/subject_card_cmp.dart';
import 'package:skill_nest/home/view_model/home_view_model.dart';
import 'package:skill_nest/video/view/video_card_cmp.dart';
import 'package:skill_nest/video/view/video_player.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewModel vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        surfaceTintColor: AppTheme.secondaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.selectedModule.title,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              vm.selectedModule.description,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color: AppTheme.secondaryBlack,
              ),
            ),
            const SizedBox(height: 20),
            vm.videoLoader
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
                    height: 500,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.50,
                      ),
                      itemCount: vm.videos.length,
                      itemBuilder: (context, index) {
                        var video = vm.videos[index];
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            vm.setselectedVideo(video);
                            print("Video url is ${video.videoUrl}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                  videoUrl: video.videoUrl,
                                ),
                              ),
                            );
                          },
                          child: VideoCardCmp(video: video),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
