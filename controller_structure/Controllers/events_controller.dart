import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:churchapp/Models/event_list_response_model.dart';
import 'package:churchapp/Models/header_image_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EventController extends GetxController {
  var latestEventList = <Event>[].obs;
  var eventList = <Event>[].obs;
  var searchedEventList = <Event>[].obs;
  var headerImage = ''.obs;

  getHeaderImage() async {
    HeaderImageViewModel headerImageViewModel = HeaderImageViewModel();
    headerImage.value = (await headerImageViewModel.getHeaderImg(tag: 'event'))
        .headerimg![0]
        .headerimg!;
  }

  getLatestEvents({bool isLoaderShow = true}) async {
    latestEventList.clear();
    var eventListViewModel = EventListViewModel();
    var eventListResponse =
        await eventListViewModel.getEventList(isLoaderShow: isLoaderShow);
    latestEventList.addAll(eventListResponse.events!);
  }

  getEvents() async {
    // latestEventList.clear();
    if (eventList.length == 0 ||
        (eventList.length >= 10 && eventList.length % 10 == 0)) {
      var eventListViewModel = EventListViewModel();
      var eventListResponse =
          await eventListViewModel.getEventList(offset: eventList.length);
      eventList.addAll(eventListResponse.events!);
    }
  }

  searchSermon({String? searchText}) async {
    searchedEventList.clear();
    var eventListViewModel = EventListViewModel();
    var eventListResponse = await eventListViewModel.searchEventList(
      searchtext: searchText.toString().trim(),
    );
    searchedEventList.addAll(eventListResponse.events!);
    print(searchedEventList.length);
  }

  void launchURL(String url) async => await canLaunch(url)
      ? await launch(url)
      : Get.showSnackbar(
          errorSnackBar(title: 'Error', message: "Unable to launch $url"),
        );
}
