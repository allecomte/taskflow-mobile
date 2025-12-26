class Project {
  String title;
  String description;
  bool isArchived;
  String startAt;
  String? endAt;

  Project({
    required this.title,
    required this.description,
    required this.isArchived,
    required this.startAt,
    this.endAt
  });


}