import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_nest/home/model/subject_model.dart';
import 'package:skill_nest/home/service/home_service.dart';
import 'package:skill_nest/modules/model/module_model.dart';
import 'package:skill_nest/modules/service/modules_service.dart';
import 'package:skill_nest/response.dart';
import 'package:skill_nest/video/model/video_model.dart';
import 'package:skill_nest/video/service/video_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchSubjects();
  }
  List<Subject> _subjects = [];
  List<Modules> _modules = [];
  List<Video> _videos = [];
  List<String> _favoriteVideoIds = [];
  List<String> _favoriteSubjectIds = [];
  bool _homeLoader = false;
  bool _moduleLoader = false;
  bool _videoLoader = false;
  late Subject _selectedsubject;
  late Modules _selectedModule;
  late Video _selectedVideo;

  List<Subject> get subjects => _subjects;
  List<Modules> get modules => _modules;
  List<Video> get videos => _videos;
  List<Video> get favoriteVideos =>
      _videos.where((v) => _favoriteVideoIds.contains(v.id)).toList();

  List<Subject> get favoriteSubjects =>
      _subjects.where((s) => _favoriteSubjectIds.contains(s.id)).toList();
  bool get homeLoader => _homeLoader;
  bool get moduleLoader => _moduleLoader;
  bool get videoLoader => _videoLoader;
  Subject get selectedSubject => _selectedsubject;
  Modules get selectedModule => _selectedModule;
  Video get selectedVideo => _selectedVideo;

  setSelectedSubject(Subject subject) {
    _selectedsubject = subject;
    notifyListeners();
  }

  setselectedModule(Modules module) {
    _selectedModule = module;
    notifyListeners();
  }

  setselectedVideo(Video video) {
    _selectedVideo = video;
    notifyListeners();
  }

  setSubjects(List<Subject> subjects) {
    _subjects = subjects;
    notifyListeners();
  }

  setModules(List<Modules> modules) {
    _modules = modules;
    notifyListeners();
  }

  setVideos(List<Video> videos) {
    _videos = videos;
    notifyListeners();
  }

  setHomeLoader(bool value) {
    _homeLoader = value;
    notifyListeners();
  }

  setModuleLoader(bool value) {
    _moduleLoader = value;
    notifyListeners();
  }

  setVideoLoader(bool value) {
    _videoLoader = value;
    notifyListeners();
  }

  fetchSubjects() async {
    setHomeLoader(true);
    HomeService service = HomeService();
    var response = await service.fetchSubjects();
    if (response is Success) {
      setSubjects(response.response as List<Subject>);
    }
    setHomeLoader(false);
  }

  fetchModules() async {
    setModuleLoader(true);
    ModulesService service = ModulesService();
    var response = await service.fetchChapters(
      subjectId: selectedSubject.id,
    );
    if (response is Success) {
      setModules(response.response as List<Modules>);
    }
    setModuleLoader(false);
  }

  fetchVideos() async {
    setVideoLoader(true);
    VideoService service = VideoService();
    var response = await service.fetchVideos(
      moduleId: selectedModule.id,
    );
    if (response is Success) {
      setVideos(response.response as List<Video>);
    }
    setVideoLoader(false);
  }
}
