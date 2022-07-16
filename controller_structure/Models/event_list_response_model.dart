import 'package:churchapp/API/api_manager.dart';
import 'package:churchapp/Controllers/church_controller.dart';
import 'package:churchapp/Helpers/constant.dart';
import 'package:get/get.dart';

class EventListResponse {
  var result;
  var message;
  List<Event>? events;

  EventListResponse({this.result, this.message, this.events});

  EventListResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      events = <Event>[];
      json['data'].forEach((v) {
        events!.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.events != null) {
      data['data'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  var eventid;
  var rid;
  var title;
  var location;
  var month;
  var day;
  var date;
  var end;
  var time;
  var endTime;
  var description;
  var recurring;
  var photo;
  var datesort;

  Event(
      {this.eventid,
      this.rid,
      this.title,
      this.location,
      this.month,
      this.day,
      this.date,
      this.end,
      this.time,
      this.endTime,
      this.description,
      this.recurring,
      this.photo,
      this.datesort});

  Event.fromJson(Map<String, dynamic> json) {
    eventid = json['eventid'];
    rid = json['rid'];
    title = json['title'];
    location = json['location'];
    month = json['month'];
    day = json['day'];
    date = json['date'];
    end = json['end'];
    time = json['time'];
    endTime = json['end_time'];
    description = json['description'];
    recurring = json['recurring'];
    photo = json['photo'];
    datesort = json['datesort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventid'] = this.eventid;
    data['rid'] = this.rid;
    data['title'] = this.title;
    data['location'] = this.location;
    data['month'] = this.month;
    data['day'] = this.day;
    data['date'] = this.date;
    data['end'] = this.end;
    data['time'] = this.time;
    data['end_time'] = this.endTime;
    data['description'] = this.description;
    data['recurring'] = this.recurring;
    data['photo'] = this.photo;
    data['datesort'] = this.datesort;
    return data;
  }
}

class EventListViewModel {
  var api = APIManager();

  /// Method used for get church sermon list from the api and return [EventListResponse]
  ///
  Future<EventListResponse> getEventList(
      {int? offset = 0, int? limit = 10, bool isLoaderShow = true}) async {
    EventListResponse response = EventListResponse();
    var churchController = Get.put(ChurchController());
    try {
      var apiResponse = await api.getAPICall(
          base_url +
              'event/${churchController.selectedChurch.value.churchid}/list/$offset/$limit',
          isLoaderShow: isLoaderShow);
      response = EventListResponse.fromJson(apiResponse);
      print(response.message);
      return response;
    } catch (e) {
      print(e.toString());
      return response;
    }
  }

  /// Method used for search events
  ///
  Future<EventListResponse> searchEventList({String? searchtext}) async {
    EventListResponse response = EventListResponse();
    var churchController = Get.put(ChurchController());
    try {
      var apiResponse = await api.getAPICall(base_url +
          'event/${churchController.selectedChurch.value.churchid}/search/$searchtext');
      response = EventListResponse.fromJson(apiResponse);
      print(response.message);
      return response;
    } catch (e) {
      print(e.toString());
      return response;
    }
  }
}
