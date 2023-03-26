class Picture {
  final String name;
  final String size;
  final String url;
  final String userUid;

  Picture({
    required this.name,
    required this.size,
    required this.url,
    required this.userUid,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      name: json['name'],
      size: json['size'],
      url: json['url'],
      userUid: json['userUid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'url': url,
      'userUid': userUid,
    };
  }
}
