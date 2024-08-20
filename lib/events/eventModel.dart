class EventsModel {
  List<Organizations>? organizations;
  Pagination? pagination;

  EventsModel({this.organizations, this.pagination});

  EventsModel.fromJson(Map<String, dynamic> json) {
    if (json['organizations'] != null) {
      organizations = <Organizations>[];
      json['organizations'].forEach((v) {
        organizations!.add(new Organizations.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.organizations != null) {
      data['organizations'] =
          this.organizations!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Organizations {
  dynamic sType;
  dynamic name;
  dynamic vertical;
  dynamic  parentId;
  dynamic  locale;
  dynamic created;
  dynamic  imageId;
  dynamic id;

  Organizations(
      {this.sType,
        this.name,
        this.vertical,
        this.parentId,
        this.locale,
        this.created,
        this.imageId,
        this.id});

  Organizations.fromJson(Map<String, dynamic> json) {
    sType = json['_type'];
    name = json['name'];
    vertical = json['vertical'];
    parentId = json['parent_id'];
    locale = json['locale'];
    created = json['created'];
    imageId = json['image_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_type'] = this.sType;
    data['name'] = this.name;
    data['vertical'] = this.vertical;
    data['parent_id'] = this.parentId;
    data['locale'] = this.locale;
    data['created'] = this.created;
    data['image_id'] = this.imageId;
    data['id'] = this.id;
    return data;
  }
}

class Pagination {
  int? objectCount;
  String? continuation;
  int? pageCount;
  int? pageSize;
  bool? hasMoreItems;
  int? pageNumber;

  Pagination(
      {this.objectCount,
        this.continuation,
        this.pageCount,
        this.pageSize,
        this.hasMoreItems,
        this.pageNumber});

  Pagination.fromJson(Map<String, dynamic> json) {
    objectCount = json['object_count'];
    continuation = json['continuation'];
    pageCount = json['page_count'];
    pageSize = json['page_size'];
    hasMoreItems = json['has_more_items'];
    pageNumber = json['page_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object_count'] = this.objectCount;
    data['continuation'] = this.continuation;
    data['page_count'] = this.pageCount;
    data['page_size'] = this.pageSize;
    data['has_more_items'] = this.hasMoreItems;
    data['page_number'] = this.pageNumber;
    return data;
  }
}
