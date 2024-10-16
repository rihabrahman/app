import 'package:demandium/feature/provider/model/provider_model.dart';

class AdvertisementModel {
  String? responseCode;
  String? message;
  AdvertisementContent? content;

  AdvertisementModel({this.responseCode, this.message, this.content});

  AdvertisementModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? AdvertisementContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class AdvertisementContent {
  int? currentPage;
  List<Advertisement>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  int? total;

  AdvertisementContent({this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.total
  });

  AdvertisementContent.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Advertisement>[];
      json['data'].forEach((v) {
        data!.add(Advertisement.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['total'] = total;
    return data;
  }
}

class Advertisement {
  String? id;
  String? readableId;
  String? title;
  String? description;
  String? providerId;
  int? priority;
  String? type;
  int? isPaid;
  String? startDate;
  String? endDate;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? promotionalVideo;
  String? providerCoverImage;
  String? providerProfileImage;
  String? providerReview;
  String? providerRating;
  ProviderData? providerData;

  Advertisement(
      {this.id,
        this.readableId,
        this.title,
        this.description,
        this.providerId,
        this.priority,
        this.type,
        this.isPaid,
        this.startDate,
        this.endDate,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.promotionalVideo,
        this.providerCoverImage,
        this.providerProfileImage,
        this.providerReview,
        this.providerRating,
        this.providerData
      });

  Advertisement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readableId = json['readable_id'];
    title = json['title'];
    description = json['description'];
    providerId = json['provider_id'];
    priority = json['priority'];
    type = json['type'];
    isPaid = json['is_paid'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    promotionalVideo = json['promotional_video'];
    providerCoverImage = json['provider_cover_image'];
    providerProfileImage = json['provider_profile_image'];
    providerReview = json['provider_review'];
    providerRating = json['provider_rating'];
    providerData = json['provider'] != null ? ProviderData.fromJson(json['provider']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['readable_id'] = readableId;
    data['title'] = title;
    data['description'] = description;
    data['provider_id'] = providerId;
    data['priority'] = priority;
    data['type'] = type;
    data['is_paid'] = isPaid;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['promotional_video'] = promotionalVideo;
    data['provider_cover_image'] = providerCoverImage;
    data['provider_profile_image'] = providerProfileImage;
    data['provider_review'] = providerReview;
    data['provider_rating'] = providerRating;
    if (providerData != null) {
      data['provider'] = providerData!.toJson();
    }
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
