import 'package:churchapp/Controllers/events_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:churchapp/Helpers/constant_widget.dart';
import 'package:churchapp/Models/event_list_response_model.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'event_details_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  var eventController = Get.put(EventController());
  var searchController = TextEditingController();

  @override
  void initState() {
    eventController.searchedEventList.clear();
    if (eventController.eventList.length == 0) {
      eventController.getEvents();
      eventController.getHeaderImage();
    }
    // eventController.getHeaderImage();

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          Obx(() => CustomAppBar(
              title: 'Events', bgImg: eventController.headerImage.value)),
          SliverPersistentHeader(
            delegate: SliverAppBarDelegate(
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Container(
                  decoration: customBoxDecoration(borderRadius: 0.0),
                  child: TextField(
                    onSubmitted: _searchEventList,
                    onChanged: (v) {
                      if (v.length == 0) {
                        eventController.searchedEventList.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    cursorColor: primaryColor,
                    controller: searchController,
                    decoration: customInputDecoration(
                        hintText: 'Search Event',
                        suffixEnable: true,
                        onSuffixTap: () =>
                            _searchEventList(searchController.text)),
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 3.0.h, top: 0.0.h, right: 3.0.h),
            child: Obx(() => eventController.eventList.length == 0
                ? text('No Latest Events Found', fontSize: 12)
                : eventController.searchedEventList.length != 0
                    ? _eventList(
                        eventList: eventController.searchedEventList,
                        ctx: context)
                    : searchController.text.isNotEmpty
                        ? text('No Events Found', fontSize: 12)
                        : _eventList(
                            eventList: eventController.eventList,
                            ctx: context)),
          ),
        ),
      ),
    );
  }

  _searchEventList(String searchText) {
    if (_validateField()) {
      FocusScope.of(context).unfocus();
      eventController.searchSermon(searchText: searchText);
    }
  }

  bool _validateField() {
    if (searchController.text.trim().isEmpty) {
      Get.showSnackbar(
          errorSnackBar(title: 'Error!', message: 'Please Enter Search Text'));
      return false;
    }
    return true;
  }

  Widget _eventList(
      {required List<Event> eventList, required BuildContext ctx}) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (eventController.searchedEventList.length == 0) {
          eventController.getEvents();
        }
      },
      child: ListView.separated(
        itemCount: eventList.length,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, i) => CustomSermonAndEventCard(
          image: eventList[i].photo,
          title: eventList[i].title,
          subtitle: eventList[i].time,
          day: eventList[i].day,
          month: eventList[i].month,
          titleFontSize: 14.0,
          onTap: () {
            FocusScope.of(context).unfocus();
            openDetailsPage(
                context: ctx,
                child: EventsDetailsScreen(
                  eventDetails: eventList[i],
                ));
          },
        ),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        reverse: false,
        separatorBuilder: (context, i) => SizedBox(width: 4.0.w),
      ),
    );
  }
}
